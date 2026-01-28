{
  disko.devices = {
    disk = {
      main = {
        device  = "/dev/sda";
        type    = "disk";
        content = {
          type       = "gpt";
          partitions = {
            boot = {
              size = "8M";
              type = "EF02";
            };

            ESP = {
              size    = "100M";
              type    = "EF00";
              content = {
                type         = "filesystem";
                format       = "vfat";
                mountpoint   = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            swap = {
              size    = "4G";
              content = {
                type          = "swap";
                discardPolicy = "both";
              };
            };

            root = {
              size    = "100%";
              content = {
                type       = "filesystem";
                format     = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
