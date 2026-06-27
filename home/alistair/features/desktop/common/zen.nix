{
  config,
  pkgs,
  inputs,
  private,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
    # or inputs.zen-browser.homeModules.twilight
    # or inputs.zen-browser.homeModules.twilight-official
  ];

  home.persistence = {
    "/persist".directories = [
      ".zen"
    ];
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    # Native messaging hosts for browser-application communication
    # Reference: https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging
    nativeMessagingHosts = [
      pkgs.firefoxpwa
      # ... more
    ];

    # Common browser policies configuration
    # Reference: https://mozilla.github.io/policy-templates/
    policies = {
      # app updates won't work in nixos anyway
      DisableAppUpdate = true;

      # disble the browser being "helpful"
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      OfferToSaveLogins = false;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        FirefoxLabs = false;
        Locked = true;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      FirefoxHome = {
        SponsoredTopSites = false;
        Stories = false;
        SponsoredPocket = false;
        SponsoredStories = false;
        Snippets = false;
      };
      NoDefaultBookmarks = true;
      DontCheckDefaultBrowser = true;

      # begone ai slop and friends
      GenerativeAI = {
        Enabled = false;
        Chatbot = false;
        LinkPreviews = false;
        TabGroups = false;
      };

      # privacy improvements
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      DisablePocket = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      # Locked preferences via policies (policies.json)
      # Use this to enforce preferences users cannot override in browser
      # These go into policies.Preferences, not regular policies
      # Reference: https://mozilla.github.io/policy-templates/#preferences
      Preferences = {
        /**
        use double quotes!
        */
        # "example.setting" = {
        #   Value = "true";
        #   Status = "locked";
        # };
      };
    };

    profiles.default = {
      # Profile settings/preferences (prefs.js)
      # User preferences that can be changed in browser
      #
      # In about:config, search "zen."
      settings = {
        /**
        use double quotes!
        */
        "zen.workspaces.continue-where-left-off" = true;
        "zen.view.compact.hide-tabbar" = true;
        "zen.urlbar.behavior" = "float";
        "zen.welcome-screen.seen" = true;
      };
      # Three-layer configuration overview:
      #
      # 1. policies (top-level, policies.json)
      #    DisableAppUpdate, DisablePocket, etc. — enforced, user can't change
      #
      # 2. policies.Preferences (in policies.json)
      #    Locked preference values like browser.startup.homepage — enforced, user can't change
      #
      # 3. profiles.*.settings (prefs.js)
      #    User preferences like zen.* settings — defaults, user can change in browser
      #
      # Key rules for profiles.*.settings:
      # - ALWAYS quote non-Zen keys: "browser.tabs.warnOnClose" = false;
      # - Don't use nested notation for browser.*: don't do browser = { tabs.warnOnClose = ... }
      # - Zen.* settings work reliably with quoted keys
      # - Settings persist to prefs.js; user can override in browser
      #
      # Troubleshooting settings not persisting: see issue #293
      # https://github.com/0xc000022070/zen-browser-flake/issues/293

      containersForce = true; # Deletes any containers not defined here on rebuild
      containers = {
        Personal = {
          color = "purple";
          icon = "fingerprint";
          id = 1;
        };
        Work = {
          color = "blue";
          icon = "briefcase";
          id = 2;
        };
        Shopping = {
          color = "yellow";
          icon = "dollar";
          id = 3;
        };
        PrivacyHell = {
          color = "red";
          icon = "fence";
          id = 4;
        };
      };

      spacesForce = true;
      spaces = {
        "General" = {
          id = "c6de089c-410d-4206-961d-ab11f988d40a";
          position = 1000;
          icon = "🏠";
        };
        "Work" = {
          id = "cdd10fab-4fc5-494b-9041-325e5759195b";
          position = 2000;
          container = 1;
          icon = "💼";
          theme = {
            type = "gradient";
            colors = [
              {
                red = 100;
                green = 150;
                blue = 200;
                algorithm = "floating";
                type = "explicit-lightness";
                lightness = 50;
              }
            ];
            opacity = 0.8;
            texture = 0.5;
          };
        };
        "Shopping" = {
          id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
          icon = "💸";
          container = 2;
          position = 3000;
          theme = {
            type = "gradient";
            colors = [
              {
                red = 200;
                green = 200;
                blue = 100;
                algorithm = "floating";
                type = "explicit-lightness";
                lightness = 50;
              }
            ];
            opacity = 0.8;
            texture = 0.5;
          };
        };
      };

      # Pinned tabs with groups, folders, and container assignment
      # Pins can be organized in folders and assigned to specific containers/spaces.
      #
      # Only if using pins or pinsForce: close Zen before home-manager switch
      # (activation script needs exclusive access to modify zen-sessions.jsonlz4)
      pinsForce = true;
      # pinsForceAction = "remove"; # omit or "demote" to keep undeclared pins as normal tabs
      pins = {
        "TubeArchivist" = {
          id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
          url = "https://tubearchive.${private.tailnet}";
          position = 101;
          isEssential = true;
        };
        "Forgejo" = {
          id = "206824e0-5ddf-4dd5-85ae-35b2d4ff83e5";
          url = "https://git.${private.tailnet}";
          position = 102;
          isEssential = true;
        };
        "Jellyfin" = {
          id = "815fcf03-c819-4bc0-8d35-112e4f9aaa9c";
          url = "https://jellyfin.${private.tailnet}";
          position = 103;
          isEssential = true;
        };
        "Home Assistant" = {
          id = "3b832bbd-886a-4dab-8529-49cc9cd5f999";
          url = "https://git.${private.tailnet}";
          position = 104;
          isEssential = true;
        };
        "Manyfold" = {
          id = "3b832bbd-886a-4dab-8529-49cc9cd5f999";
          url = "https://manyfold.${private.tailnet}";
          position = 105;
          isEssential = true;
        };
        "Nextcloud" = {
          id = "a4165b27-ccb7-4c7b-bd61-cb444f8fc0fe";
          url = "https://nextcloud.${private.tailnet}";
          position = 106;
          isEssential = true;
        };
        "GitHub" = {
          id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
          url = "https://github.com";
          position = 107;
        };
        "Dev Tools" = {
          id = "d85a9026-1458-4db6-b115-346746bcc692";
          isGroup = true;
          isFolderCollapsed = false;
          editedTitle = true;
          position = 200;
          folderIcon = "chrome://browser/skin/zen-icons/selectable/eye.svg";
        };
        "NixOS Packages" = {
          id = "f8dd784e-11d7-430a-8f57-7b05ecdb4c77";
          url = "https://search.nixos.org/packages";
          folderParentId = "d85a9026-1458-4db6-b115-346746bcc692";
          position = 201;
        };
        "NixOS Options" = {
          id = "92931d60-fd40-4707-9512-a57b1a6a3919";
          url = "https://search.nixos.org/options";
          folderParentId = "d85a9026-1458-4db6-b115-346746bcc692";
          position = 202;
        };
      };

      # Search engine configuration with custom shortcuts
      # Reference: https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox/profiles/search.nix
      search = {
        force = true; # Enforce declared search engines on each rebuild
        privateDefault = "ddg";
        default = "searxng";

        order = [
          "searxng"
          "ddg"
          "kagi"
          "brave"
          "google"
        ];
        engines = {
          "searxng" = {
            name = "SearXNG metasearch";
            description = "SearXNG is a metasearch engine that respects your privacy.";
            queryCharset = "UTF-8";
            urls = [
              {
                template = "https://search.${private.tailnet}/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                  {
                    name = "category_general";
                    value = "";
                  }
                  {
                    name = "language";
                    value = "en-GB";
                  }
                  {
                    name = "time_range";
                    value = "";
                  }
                  {
                    name = "safesearch";
                    value = "1";
                  } # 0 = off, 1 = moderate, 3 = strict
                  {
                    name = "theme";
                    value = "simple";
                  }
                ];
                rels = ["results"];
                method = "GET";
              }
              {
                "params" = [];
                "rels" = ["suggestions"];
                "template" = "https://search.pavluk.org/autocompleter?q={searchTerms}";
                "type" = "application/x-suggestions+json";
                "method" = "POST";
              }
            ];
            icon = "${pkgs.searxng}/share/static/themes/simple/img/favicon.svg";
            definedAliases = ["@searx" "@searxng"];
          };

          "kagi" = {
            urls = [
              {
                template = "https://kagi.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@kagi" "!k"];
          };

          "google" = {
            urls = [
              {
                template = "https://google.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@google" "!g"];
          };

          "jisho" = {
            urls = [
              {
                template = "https://jisho.org/search/{searchTerms}";
              }
            ];
            definedAliases = ["@jisho" "!jisho"];
          };

          "brave" = {
            urls = [
              {
                template = "https://search.brave.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@brave" "!brave"];
          };

          "ddg" = {
            urls = [
              {
                template = "https://duckduckgo.com";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@ddg" "!ddg"];
          };

          "nixos-wiki" = {
            name = "NixOS Wiki";
            urls = [
              {
                template = "https://wiki.nixos.org/w/index.php";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["!nixw"];
          };

          "youtube" = {
            name = "YouTube";
            urls = [
              {
                template = "https://www.youtube.com/results";
                params = [
                  {
                    name = "search_query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["!yt" "@yt"];
          };

          "ebay" = {
            urls = [
              {
                template = "https://www.ebay.com/sch/i.html";
                params = [
                  {
                    name = "_nkw";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["!ebay" "@ebay"];
          };

          "mynixos" = {
            name = "My NixOS";
            urls = [
              {
                template = "https://mynixos.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["!nix"];
          };

          "github" = {
            name = "GitHub Search";
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["!gh"];
          };

          "github (code)" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                  {
                    name = "type";
                    value = "code";
                  }
                ];
              }
            ];
            definedAliases = ["!ghc"];
          };

          "github (repository)" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                  {
                    name = "type";
                    value = "repository";
                  }
                ];
              }
            ];
            definedAliases = ["!ghr"];
          };

          "wikipedia".metaData.hidden = true;

          "bing".metaData.hidden = true;
        };
      };

      # Declarative keyboard shortcut overrides with version protection
      # Version protection detects breaking changes after Zen updates.
      # If modifying keyboardShortcuts: close Zen before home-manager switch
      # (activation script modifies zen-keyboard-shortcuts.json, which is locked while browser runs)
      # Version check prevents silent breakage if Zen updates change the shortcuts schema.
      #
      # Find shortcut IDs in ~/.config/zen/default/zen-keyboard-shortcuts.json
      # Get version from about:config -> zen.keyboard.shortcuts.version
      # Activation fails if version changes (prevents silent breakage).
      #
      # Use this command:
      # jq -c '.shortcuts[] | {id, key, keycode, action}' ~/.config/zen/default/zen-keyboard-shortcuts.json | fzf

      # In order to avoid breaking changes here, sometimes when you upgrade you
      # should be asked to bump this version
      keyboardShortcutsVersion = 19;

      keyboardShortcuts = [
        {
          id = "zen-compact-mode-toggle";
          key = "c";
          modifiers = {
            control = true;
            alt = true;
          };
        }
        {
          id = "zen-toggle-sidebar";
          key = "x";
          modifiers = {
            control = true;
            alt = true;
          };
        }
        {
          id = "key_quitApplication";
          disabled = true;
        }
        {
          id = "key_reload";
          key = "r";
          modifiers.control = true;
        }
        {
          id = "key_reload_skip_cache";
          key = "r";
          modifiers = {
            control = true;
            shift = true;
          };
        }
      ];

      # Declarative mod installation from Zen theme store
      # Find mod UUIDs at: https://zen-browser.app/mods
      mods = [
        "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
        "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
        "7190e4e9-bead-4b40-8f57-95d852ddc941" # Tab title fixes
        # "803c7895-b39b-458e-84f8-a521f4d7a064" # Hide Inactive Workspaces
        "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
        "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
      ];

      # Firefox extensions via rycee's NUR repository
      # Reference: https://nur.nix-community.org/repos/rycee/
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        # privacy addons
        ublock-origin
        decentraleyes
        facebook-container
        privacy-badger
        noscript

        # utilities
        violentmonkey
        gnu_terry_pratchett
        libredirect
        darkreader
        link-gopher
        ruffle_rs
        floccus
        castkodi
        bitwarden
        ipvfoo
        cookies-txt
        don-t-fuck-with-paste

        # Youtube Stuff
        dearrow
        sponsorblock
        return-youtube-dislikes
        remove-youtube-s-suggestions
        tubearchivist-companion
      ];
    };
  };
}
