{
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];
  };
}
