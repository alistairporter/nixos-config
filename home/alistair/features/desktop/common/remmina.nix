{
  services.remmina = {
    enable = true;
    addRdpMimeTypeAssoc = true;
    systemdService = {
      enable = true;
      startupFlags = [
        "--icon"
      ];
    };
  };
}
