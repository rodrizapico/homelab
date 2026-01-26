{
  description = "A collection of homelab instance configurations";
  inputs      = {
    srvos.url         ="github:nix-community/srvos";
    nixpkgs.follows   = "srvos/nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations.devpod = nixpkgs.lib.nixosSystem {
      system  = "x86_64-linux";
      specialArgs = inputs;
      modules = [ ./devpod.nix ];
    };

    nixosConfigurations.garage_s3 = nixpkgs.lib.nixosSystem {
      system      = "x86_64-linux";
      specialArgs = inputs;
      modules     = [ ./garage_s3.nix ];
    };
  };
}
