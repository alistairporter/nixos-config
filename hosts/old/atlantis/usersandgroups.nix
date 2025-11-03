{
  config,
  lib,
  pkgs,
  ...
}: {
  # Users and Groups:

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root.openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmXutLfqemWt5DqhrgIp+8xqvjw1hNmQ3U8tDWDrc89LpvUx2wIwiekUgXTa3XrfYd/PjrJnhN1N9XPCb0Fer5dp4fzZY74SepnqV2aBiOopAWiVP3ZWT48SGvM5OX26YiDOpHkfOCBLPhrBPlqLSoblHnvedzsR5V0oO62dEfgVPmSTnZRZERvfNdidVVJMODYiFeco3aFeX425FloGsjIuSDPCIu/u+iJFdNjpDah+nEsHWOuIDuIG3uvPkYWusFbuctQ6lL5I3QIJC2i++h+OvGMszPm8EH8P9KH3t+AfobudHDb5WRthdfDtWaig63tyiQrAxFZVsqDvhp/VEU0ZVQBgs2a1KV3sCpFM3rZX9lTBykthFsJvKDTj7G0fiO7Z0O1a0ajvcoPbu/WRe9PsyK7wgnz5HGMWcNFdLnFkXL51Q08jBC7/GAXsfJsw0zai22G9E0BRHQPiEjBC4CpCHWoIfXc//ife14z62DpiKm8HaDy5ZVLDoTX4Z+Dok= alistair@midgard"];
  users.users.alistair = {
    isNormalUser = true;
    createHome = true;
    extraGroups = ["wheel" "docker" "incus-admin"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    uid = 1000;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmXutLfqemWt5DqhrgIp+8xqvjw1hNmQ3U8tDWDrc89LpvUx2wIwiekUgXTa3XrfYd/PjrJnhN1N9XPCb0Fer5dp4fzZY74SepnqV2aBiOopAWiVP3ZWT48SGvM5OX26YiDOpHkfOCBLPhrBPlqLSoblHnvedzsR5V0oO62dEfgVPmSTnZRZERvfNdidVVJMODYiFeco3aFeX425FloGsjIuSDPCIu/u+iJFdNjpDah+nEsHWOuIDuIG3uvPkYWusFbuctQ6lL5I3QIJC2i++h+OvGMszPm8EH8P9KH3t+AfobudHDb5WRthdfDtWaig63tyiQrAxFZVsqDvhp/VEU0ZVQBgs2a1KV3sCpFM3rZX9lTBykthFsJvKDTj7G0fiO7Z0O1a0ajvcoPbu/WRe9PsyK7wgnz5HGMWcNFdLnFkXL51Q08jBC7/GAXsfJsw0zai22G9E0BRHQPiEjBC4CpCHWoIfXc//ife14z62DpiKm8HaDy5ZVLDoTX4Z+Dok= alistair@midgard"
    ];
    packages = with pkgs; [
      zsh
      tmux
      tree
    ];
  };
  users.users.hass = {
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrcQ7vpeANSs2xXEp16XM2ctW5ZmMPa+7vvZIhCfMj2RJ/vrrdHbJkgfnTsU45Z6t/+WClClWvfO0yWKSZUgvfo+g+1YixSUC3ZfHw6rv5U/uGP1Y/0/JBcyiapSKQTYIeqN/6Ic35ehRD/vDFjdJoC4fUfmdpbWMkHlu7ZArhDDzVKjT2r6CgnGwEYzM6dD0dxwAXLJwWxHdEDm/tBwbQNmjZVIPJw6QMTJQwabO4c5uvtAJ4V1BUT0qTLaoxHw/7l6v0AeegpFTiMLHkmFTh01b3wfGoMZmoSSJhhg0oXHkbQ9NcoatrtNtf9Xibjf5GQEpVj7CmfLP7mlmjgZJJtT1QpIoe/Bi7XFHnWi8O06cn6QWTPptMISghyDUbbwROYBCq+tAbWmW7j7g/cXyrBzlCv/lSX1F1WdSf72g/12MwlPPRhV9KCf2bJX4c/9uS6SQJx2LB+hS9C5eFTLyvsSnND84HLbEnxRd0OSPctNFcltkk6aJ6KOXbGSqJgOM= root@atlantis"];
    isNormalUser = true;
  };
  users.users.netdata = {
    extraGroups = ["docker"];
  };
}
