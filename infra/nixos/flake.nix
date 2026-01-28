{
  description = "A collection of homelab instance configurations";
  inputs      = {
    disko.url         = "github:nix-community/disko/latest";
    srvos.url         = "github:nix-community/srvos";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations.devpod = nixpkgs.lib.nixosSystem {
      system  = "x86_64-linux";
      specialArgs = inputs;
      modules = [ ./configs/devpod.nix ];
    };

    nixosConfigurations.garage_s3 = nixpkgs.lib.nixosSystem {
      system      = "x86_64-linux";
      specialArgs = inputs;
      modules     = [ ./configs/garage-s3.nix ];
    };
  };
}
