{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.server.btrfs-monitor;

  configFile = pkgs.writeText "btrfs-monitor.json" (builtins.toJSON {
    mountpoints = cfg.mountpoints;
    stateFile = cfg.stateFile;
    webhook = {
      url = cfg.webhook.url;
      method = cfg.webhook.method;
      headers = cfg.webhook.headers;
      titleTemplate = cfg.webhook.titleTemplate;
      bodyFormat = cfg.webhook.bodyFormat;
    };
  });

  monitor = pkgs.writers.writePython3Bin "btrfs-monitor" {
    flakeIgnore = ["E501"];
  } ''
    """Monitor btrfs filesystems for dropped/missing devices.

    Reads a JSON config (path passed as argv[1]), parses
    `btrfs filesystem show` for each btrfs mount, compares against
    the persisted state, and POSTs to an optional webhook when a
    device newly goes missing. Exits non-zero when any device is
    currently missing so systemd `OnFailure=` hooks can fire.

    Secret webhook URL / headers may be injected via the environment
    (BTRFS_MONITOR_WEBHOOK_URL, BTRFS_MONITOR_WEBHOOK_HEADERS as JSON)
    so they can be loaded from a sops-managed EnvironmentFile rather
    than baked into the nix store.
    """

    from __future__ import annotations

    import json
    import logging
    import os
    import re
    import socket
    import ssl
    import subprocess
    import sys
    import urllib.error
    import urllib.request

    log = logging.getLogger("btrfs-monitor")

    HEADER_RE = re.compile(r"Label:\s*(?P<label>\S+)\s+uuid:\s*(?P<uuid>\S+)")
    DEVID_RE = re.compile(
        r"^\s*devid\s+(?P<devid>\d+)\b.*?(?:path\s+(?P<path>\S+)|(?P<missing>MISSING))",
        re.IGNORECASE,
    )


    def discover_mounts():
        seen = set()
        out = []
        with open("/proc/self/mountinfo") as f:
            for line in f:
                parts = line.split(" - ", 1)
                if len(parts) != 2:
                    continue
                left, right = parts
                right_fields = right.split()
                if not right_fields or right_fields[0] != "btrfs":
                    continue
                left_fields = left.split()
                if len(left_fields) < 5:
                    continue
                mountpoint = left_fields[4]
                source = right_fields[1] if len(right_fields) > 1 else ""
                if source in seen:
                    continue
                seen.add(source)
                out.append(mountpoint)
        return out


    def parse_show(mount):
        proc = subprocess.run(
            ["btrfs", "filesystem", "show", "--raw", mount],
            capture_output=True,
            text=True,
            check=False,
        )
        if proc.returncode != 0:
            log.warning("`btrfs filesystem show %s` failed (rc=%d): %s",
                        mount, proc.returncode, proc.stderr.strip())
            return None
        label = ""
        uuid = ""
        devices = []
        for raw in proc.stdout.splitlines():
            line = raw.strip()
            if not line:
                continue
            m = HEADER_RE.search(line)
            if m:
                label = m.group("label").strip("'\"")
                uuid = m.group("uuid")
                continue
            m = DEVID_RE.match(raw)
            if m and uuid:
                devid = m.group("devid")
                path = m.group("path")
                missing = m.group("missing") is not None or path is None
                devices.append({"devid": devid, "path": path, "missing": missing})
        if not uuid:
            return None
        return {"uuid": uuid, "label": label, "mount": mount, "devices": devices}


    def collect(mountpoints):
        if not mountpoints:
            mountpoints = discover_mounts()
        seen_uuid = set()
        out = []
        for mp in mountpoints:
            fs = parse_show(mp)
            if fs is None or fs["uuid"] in seen_uuid:
                continue
            seen_uuid.add(fs["uuid"])
            out.append(fs)
        return out


    def find_dropouts(filesystems):
        out = []
        for fs in filesystems:
            for dev in fs["devices"]:
                if dev["missing"]:
                    out.append({
                        "uuid": fs["uuid"],
                        "label": fs["label"],
                        "mount": fs["mount"],
                        "devid": dev["devid"],
                        "device": dev["path"] or f"devid:{dev['devid']}",
                    })
        return out


    def signature(issue):
        return f"{issue['uuid']}:{issue['devid']}"


    def load_state(path):
        try:
            with open(path) as f:
                return json.load(f)
        except FileNotFoundError:
            return {}
        except (OSError, json.JSONDecodeError) as exc:
            log.warning("ignoring unreadable state file %s: %s", path, exc)
            return {}


    def save_state(path, state):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        tmp = f"{path}.tmp"
        with open(tmp, "w") as f:
            json.dump(state, f, indent=2, sort_keys=True)
        os.replace(tmp, path)


    def format_text(host, issues):
        lines = [f"btrfs device dropout on {host}:"]
        for issue in issues:
            lines.append(
                f"  - {issue['label']} ({issue['uuid']}) mounted at {issue['mount']}: "
                f"device {issue['device']} MISSING from the array"
            )
        return "\n".join(lines)


    def post_webhook(webhook_cfg, host, new_issues):
        url = os.environ.get("BTRFS_MONITOR_WEBHOOK_URL") or webhook_cfg.get("url")
        if not url:
            return
        title = webhook_cfg.get("titleTemplate", "btrfs dropout on {host}").format(host=host)
        body_format = webhook_cfg.get("bodyFormat", "text")
        headers = dict(webhook_cfg.get("headers") or {})
        env_headers = os.environ.get("BTRFS_MONITOR_WEBHOOK_HEADERS")
        if env_headers:
            try:
                headers.update(json.loads(env_headers))
            except json.JSONDecodeError as exc:
                log.warning("BTRFS_MONITOR_WEBHOOK_HEADERS is not valid JSON: %s", exc)
        headers.setdefault("Title", title)

        if body_format == "json":
            payload = json.dumps({
                "host": host,
                "title": title,
                "issues": new_issues,
            }).encode("utf-8")
            headers.setdefault("Content-Type", "application/json")
        else:
            payload = format_text(host, new_issues).encode("utf-8")
            headers.setdefault("Content-Type", "text/plain; charset=utf-8")

        req = urllib.request.Request(
            url,
            data=payload,
            method=webhook_cfg.get("method", "POST"),
            headers=headers,
        )
        try:
            with urllib.request.urlopen(req, timeout=15, context=ssl.create_default_context()) as resp:
                log.info("webhook %s returned HTTP %d", url, resp.status)
        except (urllib.error.URLError, socket.timeout, ssl.SSLError) as exc:
            log.error("webhook POST to %s failed: %s", url, exc)


    def main(argv):
        logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
        if len(argv) != 2:
            print(f"usage: {argv[0]} <config.json>", file=sys.stderr)
            return 2
        with open(argv[1]) as f:
            cfg = json.load(f)

        host = socket.gethostname()
        filesystems = collect(cfg.get("mountpoints") or [])
        if not filesystems:
            log.info("no btrfs filesystems found to check")
            return 0

        issues = find_dropouts(filesystems)
        state = load_state(cfg["stateFile"])
        already_notified = set(state.get("notified", []))
        current_sigs = {signature(i) for i in issues}
        new_issues = [i for i in issues if signature(i) not in already_notified]

        if new_issues:
            for line in format_text(host, new_issues).splitlines():
                log.error("%s", line)
            post_webhook(cfg.get("webhook") or {}, host, new_issues)
        elif issues:
            log.warning("%d device(s) still missing; already notified", len(issues))
        else:
            log.info("all btrfs devices present (%d filesystem(s) checked)", len(filesystems))

        save_state(cfg["stateFile"], {"notified": sorted(current_sigs), "issues": issues})
        return 1 if issues else 0


    if __name__ == "__main__":
        sys.exit(main(sys.argv))
  '';
in {
  options.custom.server.btrfs-monitor = {
    enable = lib.mkEnableOption "btrfs array dropout monitoring";

    interval = lib.mkOption {
      type = lib.types.str;
      default = "5min";
      example = "1h";
      description = ''
        How often to run the check, in systemd time-span format
        (see {manpage}`systemd.time(7)`). Used as `OnUnitActiveSec`.
      '';
    };

    mountpoints = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["/" "/media/Files"];
      description = ''
        Btrfs mountpoints to check. If empty, all currently mounted
        btrfs filesystems are auto-detected from `/proc/self/mountinfo`.
      '';
    };

    stateFile = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/btrfs-monitor/state.json";
      description = ''
        Where last-seen dropout state is persisted so a webhook only
        fires once per distinct dropout rather than every check.
      '';
    };

    webhook = {
      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "https://ntfy.example.com/btrfs-alerts";
        description = ''
          Optional HTTP endpoint to POST alerts to. Works directly
          with ntfy (set this to the topic URL). When `null` (and no
          `BTRFS_MONITOR_WEBHOOK_URL` is supplied via
          {option}`environmentFile`), no webhook is sent and alerting
          relies solely on the service exit code + journald — wire up
          notifications via `systemd.services.btrfs-monitor.onFailure`.

          For secret URLs, leave this `null` and provide the URL via
          {option}`environmentFile` so it is not stored in the nix store.
        '';
      };

      method = lib.mkOption {
        type = lib.types.enum ["POST" "PUT"];
        default = "POST";
      };

      headers = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        example = {
          Priority = "high";
          Tags = "warning,floppy_disk";
        };
        description = ''
          Extra HTTP headers sent with each webhook request. For ntfy,
          use this for `Priority`, `Tags`, etc. Secret headers (auth
          tokens) should instead be passed via
          `BTRFS_MONITOR_WEBHOOK_HEADERS` (a JSON object) in
          {option}`environmentFile`.
        '';
      };

      titleTemplate = lib.mkOption {
        type = lib.types.str;
        default = "btrfs dropout on {host}";
        description = ''
          Notification title. `{host}` is substituted with the system
          hostname. Sent as the `Title` header by default.
        '';
      };

      bodyFormat = lib.mkOption {
        type = lib.types.enum ["text" "json"];
        default = "text";
        description = ''
          Whether the POST body is human-readable text (suited to
          ntfy) or a JSON document with the structured issue list.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/secrets/btrfs-monitor.env";
        description = ''
          Path to a systemd EnvironmentFile (typically a sops-nix
          secret) supplying secret webhook settings. Recognised keys:

          - `BTRFS_MONITOR_WEBHOOK_URL` — overrides {option}`webhook.url`.
          - `BTRFS_MONITOR_WEBHOOK_HEADERS` — JSON object of headers
            merged on top of {option}`webhook.headers`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [monitor];

    systemd.services.btrfs-monitor = {
      description = "Check btrfs arrays for dropped/missing devices";
      after = ["local-fs.target"];
      path = [pkgs.btrfs-progs];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${monitor}/bin/btrfs-monitor ${configFile}";
        EnvironmentFile = lib.mkIf (cfg.webhook.environmentFile != null) cfg.webhook.environmentFile;
        StateDirectory = "btrfs-monitor";
        StateDirectoryMode = "0750";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

    systemd.timers.btrfs-monitor = {
      description = "Periodic btrfs array dropout check";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = cfg.interval;
        AccuracySec = "30s";
        Unit = "btrfs-monitor.service";
      };
    };
  };
}
