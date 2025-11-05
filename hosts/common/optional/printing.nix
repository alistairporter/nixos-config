{
  services.printing = {
    enable = true;
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
