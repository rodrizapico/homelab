{ config, pkgs, lib, ... }:

{
  boot.growPartition       = true;
  boot.loader.grub.enable  = true;
  boot.loader.grub.devices = [ "nodev" ];

  # Enable services
  services.qemuGuest.enable     = true;
  services.vscode-server.enable = true;
  virtualisation.docker.enable  = true;

  users.users.buengabacho = {
    description  = "Admin user account";
    isNormalUser = true;
    extraGroups  = [ "wheel" "docker" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGuvLnYXThp0dvDp/W7mZOnnpE9i+NClbYJwx5hsHIU"
    ];
  };
}
