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

  fileSystems."/" ={
    device     = "/dev/disk/by-label/root";
    autoResize = true;
    fsType     = "ext4";
  };

  swapDevices =[
    { device = "/dev/disk/by-label/swap"; }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
