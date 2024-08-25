{ config, lib, pkgs, pkgs-unstable, ... }:
let
  username = "dylanchen1";
  link = config.lib.file.mkOutOfStoreSymlink;
  modules = [
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/pyenv.nix
    ./programs/zoxide.nix
    ./services/gpg-agent.nix
  ];
in
{
  imports = modules;
  home = {
    inherit username;
    packages = with pkgs; [
      home-manager
      zsh
      eza
      python3
      git
      yazi
      docker
      bat
      btop
      gnupg
      du-dust
      gping
      zathura
      azure-cli
      azure-functions-core-tools
      texliveFull
      curl
      fd
      git-lfs
      gnugrep
      graphviz
      pkgs-unstable.gum
      gzip
      imagemagick
      jq
      lsof
      man
      pkgs-unstable.neovim
      nodejs
      ripgrep
      rsync
      sqlite
      tree
      time
      tlrc
      libtelnet
      wget
      unzip
      cargo
      tree-sitter
      neofetch
    ];

    homeDirectory = "/home/${username}";

    stateVersion = "23.11";

    file.".config/nvim".source = link "/home/${username}/my-home-manager/nvim";
    file.".p10k.zsh".source = link "/home/${username}/my-home-manager/terminal/.p10k.zsh";
  };
}
