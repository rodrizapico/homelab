# README

This is a set of instructions to help you set up a 'golden image' template with cloud-init to be used as a basis for building any custom images you might need using NixOS. This is by no means an optimal way of doing things, but it should be good enough to get you a working environment:

- Grab the latest NixOS release and install it into a VM (using a minimal install).
- Boot into it and login as root.
- Open `/etc/nixos/configuration.nix`, uncomment the `# services.openssh.enable = true;` line if commented, and run `nixos-rebuild switch` so you can access the VM through SSH, making it easier to work with.
- (ssh) Overwrite `/etc/nixos/configuration.nix` with the contents of the `configuration.nix` file in this dir.
- (in proxmox console - make sure to close ssh session first) Run `nixos-rebuild switch` and be patient, it's going to take some time and throw a couple errors while cloud-init tries to initialize but doesn't find a source [1]
- Run `nix-shell -p cloud-init --run "cloud-init clean --machine-id --logs --seed --configs all"`
- Run `nix-collect-garbage -d`
- Run `nixos-rebuild boot`
- Run `passwd -l root`
- Run `userdel -r nix`, and repeat if necessary for every non-root 'normal' user that exists.
- Shut down the VM.
- Add and configure a cloud-init drive. Keep the default user, no password, and disable upgrading packages.
- Ensure QEMU Guest Agent is enabled in the VM's options.
- Save as template.

[1] If you reboot the machine after running this command, you'll need to re-run every command after it.
