{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    types
    ;
    
  cfg = config.programs.nano;
in {

  options.programs.nano = {
    enable = lib.mkEnableOption "nano text editor";
    
    package = lib.mkPackageOption pkgs "nano" { example = "pkgs.nano"; };
    
    config = lib.mkOption {
      type = with lib.types; nullOr lines;
      description = ''
        The contents of the `.nanorc` file.
        If set to `null`, no file will be generated.
      '';
      default = "";
      example = ''"set atblanks"'';
    };
    
    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to configure {command}`nano` as the default
        editor using the {env}`EDITOR` environment variable.
      '';
    };
    
  };
  
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    
    home.sessionVariables = mkIf cfg.defaultEditor { EDITOR = "nano"; };
    
    xdg.configFile = {
      "nano/nanorc" = mkIf (cfg.config != { }) {
        text = cfg.config;
      };
    };
  };
}
