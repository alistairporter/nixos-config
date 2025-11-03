{
  programs.thunderbird = {
    enable = true;
    settings = {};
    profiles."alistair" = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };
}
