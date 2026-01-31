{
  description = "A collection of homelab instance configurations";
  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations.devpod = nixpkgs.lib.nixosSystem {
      system  = "x86_64-linux";
      modules = [ ./configs/devpod.nix ];
    };

    nixosConfigurations.garage_s3 = nixpkgs.lib.nixosSystem {
      system      = "x86_64-linux";
      modules     = [ ./configs/garage-s3.nix ];
    };
  };
}
