{
  config,
  lib,
  pkgs,
  ...
}: {
  # Security:

  security.polkit = {
    enable = true;
    extraConfig = ''
      /* Log authorization checks. */
      polkit.addRule(function(action, subject) {
        // Make sure to set { security.polkit.debug = true; } in configuration.nix
        polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
      });

      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel")) {
          return "yes";
        }
      });
      /* Allow any local user to do anything (dangerous!). */
      polkit.addRule(function(action, subject) {
        if (subject.local) return "yes";
      });
    '';
  };
}
