{ config, pkgs, lib, vscode-server, ... }:

{
  imports = [ 
    vscode-server.nixosModules.default
    ./base
  ];

  networking.hostName = "devpod";

  # Enable services
  services.vscode-server.enable = true;
  virtualisation.docker.enable  = true;
}
