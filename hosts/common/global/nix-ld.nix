{ pkgs, ...}:
{
  # provide comapibility environment for precompile binaries without witing nixpkgs declarations for them each time.
  programs.nix-ld = {                                                                                                                                                             
    enable = true;                                                                                                                                                                
    libraries = with pkgs;                                                                                                                                                        
      [                                                                                                                                                                           
        zlib                                                                                                                                                                      
        zstd                                                                                                                                                                      
        stdenv.cc.cc                                                                                                                                                              
        stdenv.cc.cc.lib                                                                                                                                                          
        udev                                                                                                                                                                      
        dbus                                                                                                                                                                      
        mesa                                                                                                                                                                      
        libglvnd
        libgbm
        vulkan-headers
        vulkan-loader
        vulkan-validation-layers
        curl                                                                                                                                                                      
        openssl                                                                                                                                                                   
        attr                                                                                                                                                                      
        libssh                                                                                                                                                                    
        bzip2                                                                                                                                                                     
        libxml2                                                                                                                                                                   
        acl                                                                                                                                                                       
        libsodium
        util-linux
        xz
        systemd
      ];
  };
}
