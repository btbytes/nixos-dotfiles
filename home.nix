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
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
      st = "status -sb";
      lg = "log --oneline --graph --decorate --all";
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = {
        editor = "vim";
        whitespace = "trailing-whitespace,space-before-tab";
      };
    };
    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      "*.pyc"
      ".direnv/"
    ];

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

