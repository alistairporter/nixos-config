# NixOS flake config task runner. Run `just` to list recipes.

set shell := ["bash", "-euo", "pipefail", "-c"]

flake  := justfile_directory()
host   := `hostname`
user   := env('USER', 'alistair')

# Hosts that are deployed over SSH (root login is disabled, so deploy as {{user}} + sudo)
remotes := "atlantis borealis morpheus"

# nixos-rebuild-ng: --elevate sudo works for both local activation and remote deploys
nrb := "nixos-rebuild --elevate sudo --ask-elevate-password"

# nix-output-monitor: nixos-rebuild and home-manager forward --log-format to nix, and nom
# renders the resulting json stream as a live build tree. Set NOM=0 for plain nix output
# (e.g. when redirecting to a file or running non-interactively).
use_nom   := env('NOM', '1')
nom_fmt   := if use_nom == "1" { "--log-format internal-json" } else { "" }
nom_pipe  := if use_nom == "1" { "|& nom --json" } else { "" }
nom_build := if use_nom == "1" { "nom build" } else { "nix build" }

[private]
default:
    @just --list --unsorted

# ── rebuild ────────────────────────────────────────────────────────────────────

# Build and activate a config, and make it the boot default
[group('rebuild')]
switch h=host:
    {{nrb}} switch --flake {{flake}}#{{h}} --diff {{nom_fmt}} {{nom_pipe}}

# Build and make it the boot default, but do not activate now
[group('rebuild')]
boot h=host:
    {{nrb}} boot --flake {{flake}}#{{h}} --diff {{nom_fmt}} {{nom_pipe}}

# Activate now without touching the bootloader (reverts on reboot)
[group('rebuild')]
test h=host:
    {{nrb}} test --flake {{flake}}#{{h}} --diff {{nom_fmt}} {{nom_pipe}}

# Build only, leaving a ./result symlink
[group('rebuild')]
build h=host:
    {{nrb}} build --flake {{flake}}#{{h}} {{nom_fmt}} {{nom_pipe}}

# Show what activation would do, without changing anything
[group('rebuild')]
dry h=host:
    {{nrb}} dry-activate --flake {{flake}}#{{h}} {{nom_fmt}} {{nom_pipe}}

# Build a host and diff its closure against the running system
[group('rebuild')]
diff h=host:
    {{nrb}} build --flake {{flake}}#{{h}} {{nom_fmt}} {{nom_pipe}}
    nvd diff /run/current-system ./result

# Update all flake inputs, then switch
[group('rebuild')]
upgrade h=host: update (switch h)

# Boot the config in a throwaway VM (safe way to test risky changes)
[group('rebuild')]
vm h=host:
    {{nrb}} build-vm --flake {{flake}}#{{h}} {{nom_fmt}} {{nom_pipe}}
    ./result/bin/run-*-vm

# Roll the current system back to the previous generation
[group('rebuild')]
[confirm("Roll back to the previous generation?")]
rollback:
    {{nrb}} switch --rollback

# List system generations
[group('rebuild')]
generations:
    @{{nrb}} list-generations

# ── deploy ─────────────────────────────────────────────────────────────────────

# Deploy to a remote host over SSH (builds locally, activates there)
[group('deploy')]
deploy h:
    {{nrb}} switch --flake {{flake}}#{{h}} --target-host {{user}}@{{h}} --diff {{nom_fmt}} {{nom_pipe}}

# Deploy to a remote host, activating on next reboot only
[group('deploy')]
deploy-boot h:
    {{nrb}} boot --flake {{flake}}#{{h}} --target-host {{user}}@{{h}} --diff {{nom_fmt}} {{nom_pipe}}

# Build on the remote host itself instead of locally (for foreign arches / big builds)
[group('deploy')]
deploy-remote-build h:
    {{nrb}} switch --flake {{flake}}#{{h}} --build-host {{user}}@{{h}} --target-host {{user}}@{{h}} {{nom_fmt}} {{nom_pipe}}

# Deploy sequentially to every remote host (atlantis, borealis, morpheus)
[group('deploy')]
[confirm("Deploy to all remote hosts?")]
deploy-all:
    #!/usr/bin/env bash
    set -uo pipefail
    failed=()
    for h in {{remotes}}; do
        echo "==> $h"
        just deploy "$h" || failed+=("$h")
    done
    if (( ${#failed[@]} )); then echo "FAILED: ${failed[*]}" >&2; exit 1; fi
    echo "all remotes deployed"

# Build every host defined in the flake, without deploying anything
[group('deploy')]
build-all:
    #!/usr/bin/env bash
    set -uo pipefail
    failed=()
    for h in $(just hosts); do
        echo "==> $h"
        {{nom_build}} "{{flake}}#nixosConfigurations.$h.config.system.build.toplevel" \
            --no-link --print-out-paths || failed+=("$h")
    done
    if (( ${#failed[@]} )); then echo "FAILED: ${failed[*]}" >&2; exit 1; fi

# ── home-manager ───────────────────────────────────────────────────────────────

# Activate a standalone home-manager config (non-NixOS hosts)
[group('home')]
hm cfg="deck@khazaddum":
    home-manager switch --flake {{flake}}#{{cfg}} -b backup {{nom_fmt}} {{nom_pipe}}

# Build a standalone home-manager config without activating
[group('home')]
hm-build cfg="deck@khazaddum":
    home-manager build --flake {{flake}}#{{cfg}} {{nom_fmt}} {{nom_pipe}}

# List home-manager generations
[group('home')]
hm-generations:
    home-manager generations

# ── flake ──────────────────────────────────────────────────────────────────────

# Update every flake input
[group('flake')]
update:
    nix flake update --flake {{flake}} --commit-lock-file

# Update specific inputs only, e.g. `just update-in nixpkgs home-manager`
[group('flake')]
update-in +inputs:
    nix flake update {{inputs}} --flake {{flake}} --commit-lock-file

# Evaluate all flake outputs and run checks
[group('flake')]
check:
    nix flake check {{flake}} --all-systems {{nom_fmt}} {{nom_pipe}}

# Show the flake's outputs
[group('flake')]
show:
    nix flake show {{flake}}

# Show each input's revision and last-modified date
[group('flake')]
inputs:
    @nix flake metadata {{flake}} --json \
        | jq -r '.locks.nodes | to_entries[] | select(.value.locked) | "\(.key)\t\(.value.locked.rev // .value.locked.narHash | .[0:12])\t\(.value.locked.lastModified | todate)"' \
        | column -t

# List the hostnames defined in the flake
[group('flake')]
hosts:
    @nix eval {{flake}}#nixosConfigurations --apply 'builtins.attrNames' --json | jq -r '.[]'

# Format all nix files with alejandra
[group('flake')]
fmt:
    nix fmt {{flake}}

# Check formatting without writing changes
[group('flake')]
fmt-check:
    alejandra --check {{flake}}

# Evaluate an attribute, e.g. `just eval nixosConfigurations.midgard.config.networking.hostName`
[group('flake')]
eval attr:
    @nix eval {{flake}}#{{attr}}

# Open a repl with the flake and a host's config loaded
[group('flake')]
repl h=host:
    {{nrb}} repl --flake {{flake}}#{{h}}

# Enter the dev shell (sops, age, git-crypt, home-manager, just)
[group('flake')]
shell:
    nix develop {{flake}}

# ── secrets ────────────────────────────────────────────────────────────────────

# Edit an encrypted file, e.g. `just secrets hosts/midgard/secrets.yaml`
[group('secrets')]
secrets file:
    sops {{flake}}/{{file}}

# List all sops-encrypted files
[group('secrets')]
secrets-list:
    @cd {{flake}} && ls hosts/*/secrets.yaml home/*/secrets.yaml

# Re-encrypt every secrets file to the current keys in .sops.yaml
[group('secrets')]
secrets-sync:
    #!/usr/bin/env bash
    set -euo pipefail
    cd {{flake}}
    for f in hosts/*/secrets.yaml home/*/secrets.yaml; do
        echo "==> $f"
        sops updatekeys -y "$f"
    done

# Print a host's age key, derived from its SSH host key (for .sops.yaml)
[group('secrets')]
age-key h:
    @ssh-keyscan -t ssh-ed25519 {{h}} 2>/dev/null | ssh-to-age

# Print your user age key, derived from ~/.ssh/id_ed25519.pub (for .sops.yaml)
[group('secrets')]
age-key-mine:
    @ssh-to-age -i ~/.ssh/id_ed25519.pub

# Show which git-crypt files are encrypted
[group('secrets')]
crypt-status:
    @cd {{flake}} && git-crypt status | { grep -v '^not encrypted' || true; }

# Unlock git-crypt files with your GPG key
[group('secrets')]
crypt-unlock:
    cd {{flake}} && git-crypt unlock

# ── maintenance ────────────────────────────────────────────────────────────────

# Delete system and user generations older than N days, then collect garbage
[group('maint')]
gc days="14":
    sudo nix-collect-garbage --delete-older-than {{days}}d
    nix-collect-garbage --delete-older-than {{days}}d

# Delete ALL old generations, keeping only what is currently active
[group('maint')]
[confirm("Delete all old generations? This breaks rollback.")]
gc-all:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
    sudo /run/current-system/bin/switch-to-configuration boot

# Hard-link identical files in the store to reclaim space
[group('maint')]
optimise:
    nix store optimise

# Check the store for corrupted or missing paths
[group('maint')]
verify:
    nix store verify --all --no-trust

# Re-download any corrupted store paths
[group('maint')]
repair:
    sudo nix store repair --all

# Show what is taking up space in the store
[group('maint')]
size:
    @du -sh /nix/store 2>/dev/null || true
    @nix path-info --closure-size --human-readable /run/current-system

# What is in the running system's closure, biggest first
[group('maint')]
biggest n="25":
    @nix path-info --recursive --size --human-readable /run/current-system \
        | sort -rhk2 | head -n {{n}}

# Why does the running system depend on a package? e.g. `just why python3`
[group('maint')]
why pkg:
    @nix why-depends /run/current-system {{flake}}#{{pkg}}

# Remove stray ./result build symlinks from the repo
[group('maint')]
clean:
    #!/usr/bin/env bash
    set -euo pipefail
    cd {{flake}}
    find . -name result -type l -not -path './.git/*' -print -delete

# Show news entries for the current configuration
[group('maint')]
news h=host:
    nixos-rebuild build --flake {{flake}}#{{h}} 2>&1 | { grep -A100 -i 'news\|warning' || echo "no news"; }
