{
  description = "NixOS + Home Manager Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/3abfa1fc09b62dc4cdeeb7b787886f075696f0b7";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      aihole = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          my = import ./config.nix;
        };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Back up (don't fail on) pre-existing dotfiles HM wants to
            # manage (e.g. Plasma-written gtk-3.0/4.0 settings.ini); without
            # this a single clobber aborts the whole home activation.
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit inputs;
              my = import ./config.nix;
            };
            home-manager.users.pradeep = import ./home.nix;
          }
        ];
      };
    };
  };
}
