{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    flavors = {
      rose-pine = pkgs.fetchFromGitHub {
        owner = "Mintass";
        repo = "rose-pine.yazi";
        rev = "834334048d0bc8c7c344a5a8abce0b0cb35612d3";
        sha256 = "sha256-eDJ0CsLK0ED0zl3MGfd1JtVcmwDHlkaOnliKltNneOo=";
      };
    };
    enableZshIntegration = true;
    shellWrapperName = "y";
    theme = {
      flavor = {dark = "rose-pine";};
    };
  };
}
