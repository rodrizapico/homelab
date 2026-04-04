# TODO

[X] Update devpod configuration to include docker and remove unnecessary deps
[X] Check if partition grows automatically
[X] Test running in devpod, remove manually created one
[X] autostart vms on boot
[X] make base vm able to use SSH keys passed as variables for cloud init
[X] in base VM, if nixos is enabled, force create the SSH keys

[X] make base vm not use nixos forcefully
[X] make the whole config a single var (this should simplify the next point)
[X] add validations to base VM variables so that cloud init info can only be set if no nixos; nixos is optional but if it exists must have certain values
[ ] remove hardcoded links to local infra (proxmox hosts, template names, for example)
[ ] add presets for base VM, allow to customize
[ ] clean up SSH keys generation?

[ ] add default storage location, proxmox host, template, nixos path
[ ] create k3s terraform component with configurable amount of nodes / distribute across hosts
[ ] how do I manage secrets for the base infra (proxmox keys, k3s token)? For now, I'm just using env vars in the devcontainer
[ ] Configure a backend other than local, probably by deploying a local S3-compatible service (and make sure it's encrypted)
[ ] Deploy GitLab
[ ] need to backup controplane state from laptop

## Testing

[ ] Ensure ssh keys passed to cloud init can be used (and the generated one too, in that case)
[ ] does changing the configured host rebuilds the vm or simply move it?
