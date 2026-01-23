{
  description = "A collection of homelab instance configurations";
  inputs      = {
    srvos.url         ="github:nix-community/srvos";
    nixpkgs.follows   = "srvos/nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, srvos, vscode-server }: {
  
    # Devpod config
    nixosConfigurations.devpod = nixpkgs.lib.nixosSystem {
      system  = "x86_64-linux";
      modules = [
        # Use srvos' defaults as a base
        srvos.nixosModules.server
        srvos.nixosModules.mixins-cloud-init
        srvos.nixosModules.mixins-nix-experimental
        # Enable VS Code Server
        vscode-server.nixosModules.default
        # Custom config
        ./qemu-guest-hardware-configuration.nix
        ./devpod/configuration.nix
      ];
    };
  };
}
