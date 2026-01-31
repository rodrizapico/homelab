{ config, pkgs, lib, ... }:

{
  imports = [ ./base ];

  networking.hostName = terraform.hostname or "garageS3";
}
