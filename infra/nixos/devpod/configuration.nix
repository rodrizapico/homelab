{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    tenv
  ];

  boot.loader.grub.enable  = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.growPartition       = true;

  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the qemu-guest-agent service
  services.qemuGuest.enable = true;

  # Users configuration
  users.mutableUsers = lib.mkForce true;

  # Cloud-Init configuration.
  services.cloud-init.enable = true;
  services.cloud-init.network.enable = true;
  services.cloud-init.settings = {
    users = [ "default" ];

    system_info = {
      distro = "nixos";
      network = {
        renderers = [ "networkd" ];
      };

      default_user = {
        name = "nix";
        gecos = "nixos Cloud User";
        groups = [ "wheel" ];
        isNormalUser = true;
      };
    };
  };
}