{
  config,
  inputs,
  outputs,
  pkgs,
  user,
  ...
}: {
  sops.secrets."joplin_sync_path" = {
    sopsFile = ../../secrets.yaml;
  };
  sops.secrets."joplin_sync_url" = {
    sopsFile = ../../secrets.yaml;
  };
  sops.secrets."joplin_sync_region" = {
    sopsFile = ../../secrets.yaml;
  };
  sops.secrets."joplin_sync_username" = {
    sopsFile = ../../secrets.yaml;
  };
  sops.secrets."joplin_api_token" = {
    sopsFile = ../../secrets.yaml;
  };
    
  sops.templates."joplin-settings-with-secrets.json" = {
    path = "/home/alistair/.config/joplin-desktop/settings.json";
    mode = "0600";
    content = ''
    {
      "$schema": "https://joplinapp.org/schema/settings.json",
      "sync.interval": 600,
      "sync.target": 8,
      "sync.8.path": "${config.sops.placeholder.joplin_sync_path}",
      "sync.8.url": "${config.sops.placeholder.joplin_sync_url}",
      "sync.8.region": "${config.sops.placeholder.joplin_sync_region}",
      "sync.8.username": "${config.sops.placeholder.joplin_sync_username}",
      "sync.8.forcePathStyle": true,
      "sync.maxConcurrentConnections": 30,
    	"clipperServer.autoStart": true,
      "api.token": "${config.sops.placeholder.joplin_api_token}",
      "showTrayIcon": true,
      "startMinimized": true,
      "locale": "en_GB",
      "timeFormat": "HH:mm",
      "dateFormat": "YYYY-MM-DD",
      "theme": 2,
      "markdown.plugin.softbreaks": false,
      "markdown.plugin.typographer": false,
    	"ai.chat.showToolbarButton": false,
      "spellChecker.languages": [
        "en-GB"
      ],
      "editor.codeView": false,
      "noteVisiblePanes": [
        "editor",
        "viewer"
      ],
      "ui.layout": {
        "key": "root",
        "children": [
          {
            "key": "sideBar",
            "width": 250,
            "visible": true
          },
          {
            "key": "noteList",
            "width": 250,
            "visible": true
          },
          {
            "key": "editor",
            "visible": true
          }
        ],
        "visible": true
      }
    }
    '';
  };

  programs.joplin-desktop = {
    enable = true;
  };

}
