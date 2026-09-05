{ config, pkgs, lib, inputs, ... }:

{
  # Unstraightened's Home Manager module provides `programs.doom-emacs`.
  imports = [ inputs.nix-doom-emacs-unstraightened.homeModule ];

  options.doomModule.enable = lib.mkEnableOption "Enable Nix declarative Doom Emacs (unstraightened)";

  config = lib.mkIf config.doomModule.enable {
    programs.doom-emacs = {
      enable = true;
      # Doom private dir, kept in the Nix store so enabled modules always
      # match the built dependencies. Edit files in
      # homeModules/doom/doom.d/ then rebuild.
      doomDir = ./doom.d;
      emacs = pkgs.emacs-pgtk;

      # Work around "Cannot find Git revision" errors on newer Nix.
      experimentalFetchTree = true;

      # Tree-sitter grammars are not installed automatically (see upstream
      # README). Bundle all nixpkgs grammars so `+tree-sitter` modules work.
      extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];

      # Tools Doom expects on $PATH (`doom doctor` checks for these).
      # programs.git / ripgrep / fd defaults are included automatically;
      # add the rest Doom commonly shells out to.
      extraBinPackages = with pkgs; [
        git
        ripgrep
        fd
        gnutls
        imagemagick
        sqlite
        editorconfig-core-c
        shellcheck
        shfmt
        nixfmt
        nixd
        ispell
      ];
    };

    # Doom local state lives in ~/.cache/doom, ~/.local/share/doom and
    # ~/.local/state/doom via Doom profiles (profile "nix"), not in the
    # store. Edit the files in homeModules/doom/doom.d/ then rebuild.
    home.packages = with pkgs; [
      # Fonts Doom's modeline/icons expect.
      emacs-all-the-icons-fonts
    ];
  };
}
