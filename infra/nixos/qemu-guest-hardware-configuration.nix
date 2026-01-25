{ config, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    kernelModules       = [];
    extraModulePackages = [];
    initrd              = {
      kernelModules          = [];
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];
    };
  };

  swapDevices = [
    {
      device  = "/dev/sda2";
      options = [ "discard" ];
    }
  ];

  fileSystems."/" = {
    device     = "/dev/sda3";
    autoResize = true;
    fsType     = "ext4";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
