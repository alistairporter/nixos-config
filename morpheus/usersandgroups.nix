{ config, lib, pkgs, ...}:

{
  users.users.alistair = {
    extraGroups = ["wheel" "networkmanager" "docker"];
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    hashedPassword = "SECRET_REDACTED";
  };
  users.users.hass = {
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrcQ7vpeANSs2xXEp16XM2ctW5ZmMPa+7vvZIhCfMj2RJ/vrrdHbJkgfnTsU45Z6t/+WClClWvfO0yWKSZUgvfo+g+1YixSUC3ZfHw6rv5U/uGP1Y/0/JBcyiapSKQTYIeqN/6Ic35ehRD/vDFjdJoC4fUfmdpbWMkHlu7ZArhDDzVKjT2r6CgnGwEYzM6dD0dxwAXLJwWxHdEDm/tBwbQNmjZVIPJw6QMTJQwabO4c5uvtAJ4V1BUT0qTLaoxHw/7l6v0AeegpFTiMLHkmFTh01b3wfGoMZmoSSJhhg0oXHkbQ9NcoatrtNtf9Xibjf5GQEpVj7CmfLP7mlmjgZJJtT1QpIoe/Bi7XFHnWi8O06cn6QWTPptMISghyDUbbwROYBCq+tAbWmW7j7g/cXyrBzlCv/lSX1F1WdSf72g/12MwlPPRhV9KCf2bJX4c/9uS6SQJx2LB+hS9C5eFTLyvsSnND84HLbEnxRd0OSPctNFcltkk6aJ6KOXbGSqJgOM= root@atlantis" ];
    isNormalUser = true;
  };
  users.users.netdata = {
    extraGroups = [ "docker" ];
  };
}
