{ config, pkgs, lib, terraform, ... }:
let
  sources = import ../npins;
in {
  imports = [ 
    (sources.nixos-vscode-server + "/default.nix")
    ./base
  ];

  networking.hostName = terraform.hostname;

  # Enable services
  services.vscode-server.enable = true;
  virtualisation.docker.enable  = true;
}
