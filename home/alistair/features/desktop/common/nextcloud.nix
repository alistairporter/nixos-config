{
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  home.persistence = {
    "/persist".directories = [
      "Nextcloud"
      ".config/Nextcloud"
      ".cache/Nextcloud"
    ];
  };
}
