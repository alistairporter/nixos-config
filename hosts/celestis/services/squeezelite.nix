{ config, lib, pkgs, ... }:

{
  services.squeezelite = {
    enable = true;
    pulseAudio = true;
  };
}
