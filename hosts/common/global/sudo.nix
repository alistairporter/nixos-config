let
  sw = "/run/current-system/sw/bin";
in {
  # Passwordless sudo for rebuilds, so `just switch` and friends don't prompt.
  #
  # nixos-rebuild-ng does not re-exec itself under sudo. With `--elevate sudo`
  # (what the justfile uses) it only wraps the individual privileged steps:
  # nix-env on the system profile, and `env -i ... systemd-run ...
  # switch-to-configuration`. So the helpers need rules too, not just
  # nixos-rebuild itself.
  #
  # These are root-equivalent by construction: activation runs arbitrary code
  # from the flake, and `sudo env` can exec anything. This drops the prompt,
  # not the privilege.
  security.sudo.extraRules = [
    {
      groups = ["wheel"];
      commands =
        map (command: {
          inherit command;
          options = ["NOPASSWD" "SETENV"];
        }) [
          "${sw}/nixos-rebuild" # sudo nixos-rebuild switch ...
          "${sw}/nix-env" # --elevate sudo: set/list/rollback the system profile
          "${sw}/env" # --elevate sudo: env -i ... switch-to-configuration
          "${sw}/systemd-run" # ditto, when no env vars are forwarded
          "${sw}/nix-channel" # nixos-rebuild --upgrade
        ];
    }
  ];
}
