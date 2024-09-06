{ nixpkgs, nixpkgs-unstable, config, lib, ... }:
{
  programs.git = {
    enable = true;
    userEmail = "dylanchen1@kpmg.co.nz";
    userName = "dchenkpmg";
    signing.key = "ED5E1515657E21FC";
    aliases = {
      graph = "log --all --graph --decorate --oneline";
    };
    ignores = [
      ".DS_Store"
    ];
    extraConfig = {
      credential = {
        helper = "/mnt/c/Users/dylanchen1/AppData/Local/Programs/Git/mingw64/bin/git-credential-manager.exe";
      };
      core = {
        excludesfile = "/home/dylanchen1/.gitignore_global";
      };
      "credential \"https://dev.azure.com\"" = {
        useHttpPath = true;
      };
      commit = {
        gpgsign = true;
      };
      init = {
        defaultBranch = "main";
      };
      "includeIf \"gitdir:~/personal-projects/\"" = {
        path = "~/personal-projects/.gitconfig";
      };
    };
  };
}
