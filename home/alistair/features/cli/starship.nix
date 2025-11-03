{
  pkgs,
  misc,
  ...
}: {
  #
  # Starship custom shell prompt
  #
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      character = {
        error_symbol = "[λ](bold red)";
        success_symbol = "[λ](bold green)";
      };
      cmd_duration.min_time = 60000;
      directory = {
        format = "\\[[$path]($style)\\][$read_only]($read_only_style) ";
        read_only = " ro";
      };

      format = "$character$username$hostname$all→ ";

      git_branch.symbol = "git ";
      git_commit.tag_symbol = " tag ";
      git_status = {
        ahead = ">";
        behind = "<";
        deleted = "x";
        diverged = "<>";
        renamed = "r";
      };

      hostname = {
        disabled = false;
        format = " [$ssh_symbol](bold red)\\[[$hostname](green)\\] ";
        ssh_only = false;
        ssh_symbol = "remote ";
        style = "green bold";
        trim_at = "";
      };

      line_break.disabled = true;

      status.symbol = "[x](bold red) ";

      username = {
        disabled = false;
        format = "[$user]($style)";
        show_always = true;
        style_root = "red bold";
        style_user = "yellow bold";
      };

      # overide default icons with sensible text, "hacker fonts" can get in the bin.
      aws.symbol = "aws ";
      azure.symbol = "az ";
      bun.symbol = "bun ";
      c.symbol = "C ";
      cmake.symbol = "cmake ";
      cobol.symbol = "cobol ";
      conda.symbol = "conda ";
      crystal.symbol = "cr ";
      daml.symbol = "daml ";
      dart.symbol = "dart ";
      deno.symbol = "deno ";
      docker_context.symbol = "docker ";
      dotnet.symbol = ".NET ";
      elixir.symbol = "exs ";
      elm.symbol = "elm ";
      fennel.symbol = "fnl ";
      fossil_branch.symbol = "fossil ";
      gcloud.symbol = "gcp ";
      golang.symbol = "go ";
      gradle.symbol = "gradle ";
      guix_shell.symbol = "guix ";
      hg_branch.symbol = "hg ";
      java.symbol = "java ";
      julia.symbol = "jl ";
      kotlin.symbol = "kt ";
      lua.symbol = "lua ";
      memory_usage.symbol = "memory ";
      meson.symbol = "meson ";
      nim.symbol = "nim ";
      nix_shell.symbol = "nix ";
      nodejs.symbol = "nodejs ";
      ocaml.symbol = "ml ";
      opa.symbol = "opa ";
      package.symbol = "pkg ";
      perl.symbol = "pl ";
      php.symbol = "php ";
      pijul_channel.symbol = "pijul ";
      pulumi.symbol = "pulumi ";
      purescript.symbol = "purs ";
      python.symbol = "py ";
      raku.symbol = "raku ";
      ruby.symbol = "rb ";
      rust.symbol = "rs ";
      scala.symbol = "scala ";
      solidity.symbol = "solidity ";
      spack.symbol = "spack ";
      sudo.symbol = "sudo ";
      swift.symbol = "swift ";
      terraform.symbol = "terraform ";
      zig.symbol = "zig ";
      os.symbols = {
        Alpaquita = "alq ";
        Alpine = "alp ";
        Amazon = "amz ";
        Android = "andr ";
        Arch = "rch ";
        Artix = "atx ";
        CentOS = "cent ";
        Debian = "deb ";
        DragonFly = "dfbsd ";
        Emscripten = "emsc ";
        EndeavourOS = "ndev ";
        Fedora = "fed ";
        FreeBSD = "fbsd ";
        Garuda = "garu ";
        Gentoo = "gent ";
        HardenedBSD = "hbsd ";
        Illumos = "lum ";
        Linux = "lnx ";
        Mabox = "mbox ";
        Macos = "mac ";
        Manjaro = "mjo ";
        Mariner = "mrn ";
        MidnightBSD = "mid ";
        Mint = "mint ";
        NetBSD = "nbsd ";
        NixOS = "nix ";
        OpenBSD = "obsd ";
        OpenCloudOS = "ocos ";
        OracleLinux = "orac ";
        Pop = "pop ";
        Raspbian = "rasp ";
        RedHatEnterprise = "rhel ";
        Redhat = "rhl ";
        Redox = "redox ";
        SUSE = "suse ";
        Solus = "sol ";
        Ubuntu = "ubnt ";
        Unknown = "unk ";
        Windows = "win ";
        openEuler = "oeul ";
        openSUSE = "osuse ";
      };
    };
  };
}
