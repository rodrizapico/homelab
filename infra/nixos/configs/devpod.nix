{ config, pkgs, lib, terraform, ... }:
let
  sources = import ../npins;
in {
  imports = [ 
    (sources.nixos-vscode-server + "/default.nix")
    ./base
  ];

  # Enable services
  services.vscode-server.enable = true;
  virtualisation.docker.enable  = true;
}
