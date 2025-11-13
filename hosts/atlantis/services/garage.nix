{
  pkgs,
  config,
  lib,
  ...
}:
let
  root_domain = "aporter.xyz";
  s3_port = 3900;
  rpc_port = 3901;
  s3_web_port = 3902;
  admin_port = 3903;
in {

  users.users.garage = {
    isSystemUser = true;
    group = "garage";
    home = "/var/lib/garage";
  };

  users.groups.garage = {};
  sops.secrets = {
    garage_rpc_secret = {
      sopsFile = ../secrets.yaml;
      owner = "garage";
      group = "garage";
      mode = "0600";
    };
    garage_admin_token = {
      sopsFile = ../secrets.yaml;
      owner = "garage";
      group = "garage";
      mode = "0600";
    };
    garage_metrics_token = {
      sopsFile = ../secrets.yaml;
      owner = "garage";
      group = "garage";
      mode = "0600";
    };
    garage_webui_env = {
      sopsFile = ../secrets.yaml;
    };
  };

  services.garage = {
    enable = true;
    package = pkgs.garage_2;
    extraEnvironment = {
      RUST_BACKTRACE = "yes";
      RUST_LOG = "garage=debug";
    };
    settings = {
      metadata_dir = "/media/MiscFiles/garage/metadata";
      data_dir = [
        {
          path = "/media/MiscFiles/garage/data";
          capacity = "1T";
        }
      ];

      replication_factor = 1;
      
      # it's *NOT* world-readable, however not was garage exepects either
      # Jun 20 17:27:39 x64-linux-dev-01 garage[1701365]: Error: File /run/secrets/GARAGE_RPC_SECRET is world-readable! (mode: 0100440, expected 0600)
      allow_world_readable_secrets = true;

      rpc_bind_addr = "[::]:${toString rpc_port}";
      rpc_secret_file = config.sops.secrets.garage_rpc_secret.path;

      s3_api = {
        api_bind_addr = "[::]:${toString s3_port}";
        s3_region = "garage";
        root_domain = ".s3.${root_domain}";
      };

      s3_web = {
        bind_addr = "[::]:${toString s3_web_port}";
        root_domain = ".web.${root_domain}";
      };

      admin = {
        api_bind_addr = "0.0.0.0:${toString admin_port}";
        metrics_token_file = config.sops.secrets.garage_metrics_token.path;
        admin_token_file = config.sops.secrets.garage_admin_token.path;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ s3_port rpc_port s3_web_port admin_port ]; # Facilitate firewall punching

  services.garage-webui = {
    enable = true;
    package = pkgs.garage-webui;
    openFirewall = true;
    environment = {
      "API_BASE_URL" = "http://atlantis.dropbear-monster.ts.net:3903";
      "S3_ENDPOINT" = "s3.aporter.xyz";
      "S3_REGION" = "garage";
    };
    environmentFile = config.sops.secrets.garage_webui_env.path;
    configuration = {};
    # configuration = config.services.garage.settings;
  };
}
