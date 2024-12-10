{ config, lib, pkgs, pkgs-unstable, ... }:
let
  username = "dylanchen1";
  link = config.lib.file.mkOutOfStoreSymlink;
  modules = [
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/zoxide.nix
    ./programs/git.nix
    ./programs/zathura.nix
    ./programs/btop.nix
    ./programs/yazi.nix
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
      gcc
      eza
      docker
      bat
      gnupg
      du-dust
      gping
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
      pkgs-unstable.cargo
      tree-sitter
      neofetch
      pkgs-unstable.lazygit
      at-spi2-core
      fontconfig
      lsix
      wsl-open
      pkgs-unstable.ttyper
      pkgs-unstable.go
    ];

    homeDirectory = "/home/${username}";

    stateVersion = "23.11";

    file.".config/nvim".source = link "/home/${username}/my-home-manager/nvim";
    file.".p10k.zsh".source = link "/home/${username}/my-home-manager/terminal/.p10k.zsh";
  };
}
