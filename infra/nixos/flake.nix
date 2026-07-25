{
  description = "A collection of homelab instance configurations";
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.cloudinit = nixpkgs.lib.nixosSystem {
      system  = "x86_64-linux";
      modules = [ ./configs/cloudinit.nix ];
    };

    nixosConfigurations.devpod = nixpkgs.lib.nixosSystem {
      system  = "x86_64-linux";
      modules = [ ./configs/devpod.nix ];
    };

    nixosConfigurations.garage_s3 = nixpkgs.lib.nixosSystem {
      system      = "x86_64-linux";
      modules     = [ ./configs/garage-s3.nix ];
    };

    nixosConfigurations.k3s_server = nixpkgs.lib.nixosSystem {
      system      = "x86_64-linux";
      modules     = [ ./configs/k3s-server.nix ];
    };
  };
}
