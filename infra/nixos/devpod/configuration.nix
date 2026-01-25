{ config, pkgs, lib, ... }:

{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  boot.growPartition       = true;
  boot.loader.grub.enable  = true;
  boot.loader.grub.devices = [ "nodev" ];

  console.keyMap = "es";

  # Override SrvOS's default value to allow cloud-init to set a user's authorized_keys
  services.openssh.authorizedKeysFiles = lib.mkOverride 40 [
    ".ssh/authorized_keys"
    "/etc/ssh/authorized_keys.d/%u"
  ];

  # Allow managing users outside of NixOS config
  users.mutableUsers = lib.mkForce true;

  # Enable services
  services.qemuGuest.enable     = true;
  services.vscode-server.enable = true;
  virtualisation.docker.enable  = true;

  users.users.buengabacho = {
    description  = "Admin user account";
    isNormalUser = true;
    extraGroups  = [ "wheel" "docker" ];

    openssh.authorizedKeys.keys = [
      # Bitwarden SSH key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGuvLnYXThp0dvDp/W7mZOnnpE9i+NClbYJwx5hsHIU"
    ];
  };
}
