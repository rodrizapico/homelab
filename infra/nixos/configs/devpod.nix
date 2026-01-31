{ config, pkgs, lib, terraform, ... }:
let
  sources = import ../nix/sources.nix;
in {


  imports = [ 
    sources.nixos-vscode-server
    ./base
  ];

  networking.hostName = terraform.hostname or "devpod";

  # Enable services
  services.vscode-server.enable = true;
  virtualisation.docker.enable  = true;
}
