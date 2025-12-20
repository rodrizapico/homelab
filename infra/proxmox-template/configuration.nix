{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  # Enable passwordless sudo for wheel users
  security.sudo = {
    enable = true;
    extraRules = [{
      groups = [ "wheel" ];
      commands= [{
        command = "ALL";
        options = [ "NOPASSWD" ];
      }];
    }];
  };

  # Network configuration should be managed by cloud-init.
  networking.useDHCP = false;
  networking.interfaces = {};

  # Enable the qemu-guest-agent service.
  services.qemuGuest.enable = true;

  # Configure SSH
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;

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