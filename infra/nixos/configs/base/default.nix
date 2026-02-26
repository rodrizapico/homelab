{ config, pkgs, lib, terraform, ... }:
let
  sources = import ../../npins;
in {
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?


  imports = [
    ./disk-config.nix
    (sources.disko + "/module.nix")
    # Use srvos' defaults as a base
    (sources.srvos + "/nixos/server/default.nix")
    (sources.srvos + "/nixos/mixins/cloud-init.nix")
    (sources.srvos + "/nixos/mixins/nix-experimental.nix")
    ./qemu-guest-hardware-configuration.nix
  ];

  # Use grub as the bootloader
  boot.loader.grub.enable  = true;

  # Switch keyboard layout to spanish
  console.keyMap = "es";

  # Enable qemu guest agent
  services.qemuGuest.enable = true;

  # Override SrvOS's default value to allow cloud-init to set a user's authorized_keys
  services.openssh.authorizedKeysFiles = lib.mkOverride 40 [
    ".ssh/authorized_keys"
    "/etc/ssh/authorized_keys.d/%u"
  ];

  # Ensure cloud-init's default user belongs to wheel
  services.cloud-init.settings = {
    users = [ "default" ];

    system_info.default_user = {
      name = "nix";
      gecos = "nixos Cloud User";
      groups = [ "wheel" ];
      isNormalUser = true;
    };
  };

  users = {
    mutableUsers = lib.mkForce true;
    users.${terraform.username} = {
      description  = "Admin user account";
      isNormalUser = true;
      extraGroups  = [ "wheel" "docker" ];
      openssh.authorizedKeys.keys = terraform.ssh_keys;
    };
  };
}
