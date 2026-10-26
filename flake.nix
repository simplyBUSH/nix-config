{
  description = "personal nix configs";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-amd-ai.url = "github:noamsto/nix-amd-ai";
    bnm.url = "github:dopeCape/better-nm";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, chaotic, nix-amd-ai, ... }: {
    nixosConfigurations."jolteon" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/jolteon
        home-manager.nixosModules.home-manager
        inputs.bnm.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.bush = import ./home/systems/jolteon.nix;
          home-manager.backupFileExtension = "backup";
        }
        chaotic.nixosModules.default
      ];
    };

    nixosConfigurations."sylveon" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/sylveon
        home-manager.nixosModules.home-manager
        nix-amd-ai.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.bush = import ./home/systems/sylveon.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
