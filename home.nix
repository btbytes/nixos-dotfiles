{ config, pkgs, ... }:

{

  home.username = "pradeep";
  home.homeDirectory = "/home/pradeep";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    c3c
    devenv
    dotnet-sdk_10
    dmd
    emacs-pgtk
    factor-lang
    fastfetch
    fd
    fzf
    gh
    ghostty
    go
    google-chrome
    gopls
    htop
    jdk25
    jq
    kitty
    odin
    nix-index
    qtcreator
    quickshell
    ripgrep
    rustup
    sbcl
    scala
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell"; # e.g., "agnoster", "amuse", etc.
      plugins = [
        "git"
        "sudo"
        "fzf"
        "docker"
        "direnv"
      ];
    };

    # Shell aliases
    shellAliases = {
      e = "emacsclient -c -a ''";
      et = "emacsclient -t";
      ll = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;


  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    startWithUserSession = "graphical";
  };
}

