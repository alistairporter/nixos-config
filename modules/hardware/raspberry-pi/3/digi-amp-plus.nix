{config, lib, ...}:

let
  cfg = config.hardware.raspberry-pi."3".digi-amp-plus;
in
{
  options.hardware = {
    raspberry-pi."3".digi-amp-plus = {
      enable = lib.mkEnableOption ''
        support for the IQaudIO DigiAMP+ Hat.
      '';

      unmuteAmp = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          "one-shot" unmute when kernel module first loads.
        '';
      };

      autoMuteAmp = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Unmute the amp when an ALSA device is opened by a client. Mute, with a five-second delay when the ALSA device is closed.
          (Reopening the device within the five-second close window will cancel mute.)
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    hardware.raspberry-pi."3".apply-overlays-dtmerge.enable = lib.mkDefault true;
  
    hardware.deviceTree = {
      overlays = [
        # Adapted from https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/digi-amp-plus.nix
        # changes:
        # - modified top-level "compatible" field from bcm2711 to bcm2835
        # - s/i2s/i2s_clk_producer/ (name on bcm2710 platform)
        {
          name = "iqaudio-digiampplus-overlay";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            / {
              compatible = "brcm,bcm2837";

              fragment@0 {
                target = <&i2s_clk_producer>;
                __overlay__ {
                  status = "okay";
                };
              };

              fragment@1 {
                target = <&i2c1>;
                __overlay__ {
                  #address-cells = <1>;
                  #size-cells = <0>;
                  status = "okay";

                  pcm5122@4c {
                    #sound-dai-cells = <0>;
                    compatible = "ti,pcm5122";
                    reg = <0x4c>;
                    AVDD-supply = <&vdd_3v3_reg>;
                    DVDD-supply = <&vdd_3v3_reg>;
                    CPVDD-supply = <&vdd_3v3_reg>;
                    status = "okay";
                  };
                };
              };
              
              fragment@2 {
                target = <&sound>;
                iqaudio_dac: __overlay__ {
                  compatible = "iqaudio,iqaudio-dac";
                  i2s-controller = <&i2s_clk_producer>;
                  mute-gpios = <&gpio 22 0>;
                  status = "okay";
                  ${lib.optionalString cfg.unmuteAmp "iqaudio-dac,unmute-amp;"}
                  ${lib.optionalString cfg.autoMuteAmp "iqaudio-dac,auto-mute-amp;"}
                };
              };
            };
          '';
        }
      ];
    };
  };
}
