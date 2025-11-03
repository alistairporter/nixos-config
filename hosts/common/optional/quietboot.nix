{
  pkgs,
  config,
  ...
}: {
  console = {
    useXkbConfig = true;
    earlySetup = false;
  };

  boot = {
    plymouth = {
      enable = true;
      theme = "spinner-monochrome";
      themePackages = [
        (pkgs.plymouth-spinner-monochrome.override {inherit (config.boot.plymouth) logo;})
      ];
    };
    loader.timeout = 0;
    # Enable "Silent boot"
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "boot.shell_on_fail"
      "systemd.show_status=auto"
      "rd.systemd.show_status=auto"
      "udev.log_priority=3"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
}
