{ pkgs, misc, inputs, ... }: {
  
  programs.ssh = {
    enable = true;
    serverAliveInterval = 100;
    matchBlocks = {
      "morpheus.aporter.xyz" = {
        host = "morpheus.aporter.xyz";
        hostname = "10.10.10.1";
        proxyJump = "alistair@aporter.xyz";
      };
      "atlantis.aporter.xyz" = {
        host = "atlantis.aporter.xyz";
        hostname = "10.10.10.2";
        proxyJump = "alistair@aporter.xyz";
      };
      "borealis.aporter.xyz" = {
        host = "borealis.aporter.xyz";
        hostname = "10.10.10.3";
        proxyJump = "alistair@aporter.xyz";
      };
      "olympus.aporter.xyz" = {
        host = "olympus.aporter.xyz";
        hostname = "10.10.10.4";
        proxyJump = "alistair@aporter.xyz";
      };
    };
  };
}
