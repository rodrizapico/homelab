{ config, pkgs, lib, disko, srvos, ... }:

{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  imports = [
    ./disk-config.nix
    disko.nixosModules.disko
    # Use srvos' defaults as a base
    srvos.nixosModules.server
    srvos.nixosModules.mixins-cloud-init
    srvos.nixosModules.mixins-nix-experimental
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
    users.buengabacho = {
      description  = "Admin user account";
      isNormalUser = true;
      extraGroups  = [ "wheel" "docker" ];

      openssh.authorizedKeys.keys = [
        # Bitwarden SSH key
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGuvLnYXThp0dvDp/W7mZOnnpE9i+NClbYJwx5hsHIU"
      ];
    };
  }
}
