{ config, pkgs, ... }:

{

  home.username = "pradeep";
  home.homeDirectory = "/home/pradeep";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    htop
    fastfetch
    ripgrep
    fd
    tree
    fzf

    # add desktop programs  
  ];

  programs.git = {
    enable = true;
    userName = "Pradeep Gowda";
    userEmail = "pradeep@btbytes.com";
  };


  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
    };
  };

  programs.home-manager.enable = true;
}

