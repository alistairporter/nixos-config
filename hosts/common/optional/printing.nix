{
  pkgs,
  ...
}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint hplip ];
    webInterface = false;
    cups-pdf = {
      enable = true;
      instances."pdf" = {
        settings = {
          Anonuser = "";
          Out = "\${HOME}/Downloads";
        };
      };
    };
  };
}
