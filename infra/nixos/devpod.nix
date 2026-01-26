{ config, pkgs, lib, vscode-server, ... }:

{
  imports = [ 
    vscode-server.nixosModules.default
    ./base.nix
  ];

  services.vscode-server.enable = true;
  virtualisation.docker.enable  = true;
}
