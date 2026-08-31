{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.yazi = {
    enable = false;
    package = pkgs-unstable.yazi;
    flavors = {
      rose-pine = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "yazi";
        rev = "c89d745573d4fcfe0550fe6646f9f9ab1c0e51db";
        sha256 = "sha256-9e3dXViWl1rK9BPrGAFfs9ZL/tsG6Njz6ksuU6AIrFY=";
      };
    };
    theme = {
      flavor = {dark = "rose-pine";};
    };
  };
}
