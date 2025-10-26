{ config, lib, pkgs, ... }:

{
  services.squeezelite = {
    enable = false;
    pulseAudio = true;
  };
}
