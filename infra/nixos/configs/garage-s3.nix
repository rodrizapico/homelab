{ config, pkgs, lib, ... }:

{
  imports = [ ./base ];

  networking.hostName = "garage-s3";
}
