{ pkgs, misc, ... }: {
  # shell history sync
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      sync_address = "https://atuin.aporter.xyz";
      sync_frequency = "0";
      dialect = "uk";
      secrets_filter = true;
      search_mode = "fulltext";
      filter_mode = "global";
      filter_mode_shell_up_key_binding = "host";
      enter_accept = false;
    };
  };
}
