{ config, pkgs, ...}:{

  time.timeZone = "Europe/London";

  i18n.extraLocaleSettings = {
    LC_COLLATE = "C.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  location.provider = "geoclue2";
}
