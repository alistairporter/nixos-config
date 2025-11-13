{ config, lib, pkgs, ...}:
let
  cfg = config.services.garage-webui;
in
{
  options = {
    services.garage-webui = {
      enable = lib.options.mkEnableOption "Enable garage-webui service";

      package = lib.options.mkPackageOption pkgs "garage-webui" {};

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open the default ports in the firewall for the garage-webui server. The
          port can be changed in the config or though the environment variables, so this option should
          only be used if they are unchanged, see [Running](https://github.com/khairul169/garage-webui#running).
        '';
      };
           
      environment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = '''
          Environment variables for configuring the garage-webui service.
          This field will end up public in /nix/store, for secret values (such as `KEY`) use `environmentFile`.

          See <https://github.com/khairul169/garage-webui#environment-variables> for available options.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          File path containing environment variables for configuring the garage-webui service in the format of an EnvironmentFile. See {manpage}`systemd.exec(5)`.
        '';
      };

      configuration = lib.options.mkOption {
        description = "Nix expression that will be written to config file.";
        default = {};
        type = lib.types.attrs;
        example = ''
          {
            topic = {
              default = "prometheusalerts";
              label = "topic";
            };
            ntfy = {
              url = "https://ntfy.example.com/";
              username = "user";
              password = "password";
            };
            templates = {
              title = "...";
              message = ''''''
                abcd
                '''''';
            };
          }
          '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    # TODO: Integrate this better with systemd for privacy.
    environment.etc."garage-webui/config.toml" = {
      # Ref: https://github.com/NixOS/nixpkgs/blob/4ffc4dc91838df228c8214162c106c24ec8fe03f/nixos/modules/programs/starship.nix#L10
      source = (pkgs.formats.toml {}).generate "config.toml" cfg.configuration;
      mode = "0444";
    };
    
    systemd.services.garage-webui = {
      description = "Web UI for Garage";
      
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target"];
      
      environment = cfg.environment;

      serviceConfig = {
        EnvironmentFile = cfg.environmentFile;
        ExecStart = "${cfg.package}/bin/garage-webui";
        StateDirectory = "/var/lib/garage-webui";
        DynamicUser = true;
        Restart = "on-failure";
        AmbientCapabilities = "cap_net_bind_service";
        RestartSec = 5;
      };
      unitConfig = {
        StartLimitIntervalSec = 0;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        3909
      ];
    };
  };
}
