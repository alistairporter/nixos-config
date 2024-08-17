# Fleek Configuration

nix home-manager configs created by [fleek](https://github.com/ublue-os/fleek).

## Reference

- [home-manager](https://nix-community.github.io/home-manager/)
- [home-manager options](https://nix-community.github.io/home-manager/options.html)

## Usage

Aliases were added to the config to make it easier to use. To use them, run the following commands:

```bash
# To change into the fleek generated home-manager directory
$ fleeks
# To apply the configuration
$ apply-$(hostname)
```

Your actual aliases are listed below:
    apply-atlantis = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@atlantis";

    apply-khazaddum = "nix run --impure home-manager/master -- -b bak switch --flake .#deck@khazaddum";

    apply-midgard = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@midgard";

    apply-morpheus = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@morpheus";

    apply-olympus = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@olympus";

    cp = "cp -i";

    dud = "du -d 1 -h";

    fleeks = "cd ~/.local/share/fleek";

    l = "ls -lh";

    latest-fleek-version = "nix run https://getfleek.dev/latest.tar.gz -- version";

    lsa = "ls -lah";

    mv = "mv -i";

    neofetch = "fastfetch";

    t = "tail -f";

    update-fleek = "nix run https://getfleek.dev/latest.tar.gz -- update";
