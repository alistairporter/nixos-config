{
  config,
  pkgs,
  inputs,
  ...
}:
{
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
    
    policies = let
      mkLockedAttrs = builtins.mapAttrs (_: value: {
        Value = value;
        Status = "locked";
      });
    in {
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

      # Set some browser preferences
      Preferences = mkLockedAttrs {
        "zen.view.use-single-toolbar" = false; 
      };
    };

    profiles."alistair" = {
      containersForce = true;
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
      spaces = let
        containers = config.programs.zen-browser.profiles."alistair".containers;
      in {
        "Space" = {
          id = "c6de089c-410d-4206-961d-ab11f988d40a";
          position = 1000;
        };
        "Work" = {
          id = "cdd10fab-4fc5-494b-9041-325e5759195b";
          icon = "chrome://browser/skin/zen-icons/selectable/star-2.svg";
          container = containers."Work".id;
          position = 2000;
        };
        "Shopping" = {
          id = "78aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
          icon = "💸";
          container = containers."Shopping".id;
          position = 3000;
        };
      };

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
