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
    tmux
    # add desktop programs  
    google-chrome

    # programming languages
    go
    gopls
    rustup
  ];

  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      "*.pyc"
      ".direnv/"
    ];

    settings = {
      user = {
        name = "Pradeep Gowda";
        email = "pradeep@btbytes.com";
      };

      alias = {
        ci = "commit";
        co = "checkout";
        s = "status";
        st = "status -sb";
        lg = "log --oneline --graph --decorate --all";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = {
        editor = "vim";
        whitespace = "trailing-whitespace,space-before-tab";
      };
    };
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

