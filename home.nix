{ config, pkgs, ... }:

{

  home.username = "pradeep";
  home.homeDirectory = "/home/pradeep";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    devenv
    dmd
    emacs
    fastfetch
    fd
    fzf
    gh
    go
    google-chrome
    gopls
    htop
    jdk25
    jq
    nix-index
    ripgrep
    rustup
    sbcl
    scala
    sublime4
    tmux
    tree
    unzip
    uv
    vscode
    zed-editor
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}

