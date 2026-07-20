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
[X] remove hardcoded links to local infra (proxmox hosts, template names, for example)
[X] add presets for base VM, allow to customize by having additional 'advanced' settings
[X] check if validations work when specified only on the child module
[X] add default storage location, proxmox host, template, nixos path
[X] create k3s terraform component with configurable amount of nodes / distribute across hosts
[X] remove atmos vm component catalog, since it's pretty much redundant now we have hardware presets
[X] migrate from using Telmate proxmox provider to BPG
[X] use q35 as machine type
[X] the template and custom cloud init config should be it's own (root) component to be reused by others
[X] use a cloud template so that we don't depend on a preconfigured image
[X] test a different cloudinit image, since the arch one doesn't seem to work with nixos-anywhere

[ ] export private/public SSH keys somehow
[ ] try out ovmf (uefi)
[ ] remove ssh dependency for VM provisioning
[ ] use CPU limit to add a xs preset with 0.5cpu
[ ] improve node selection logic
[ ] clear up stage usage
[ ] if no user is passed, we need to give an output with valid user/private key OR we need to make ssh_keys mandatory
[ ] add a LB to k3s cluster
[ ] use terraform's DNS provider to dynamically assign URL's to new instances
[ ] clean up SSH keys generation?
[ ] maybe use a bastion host that holds all SSH keys instead of using my own for everything?
[ ] add k3s outputs

[ ] manage env variables like proxmox default values
[ ] how do I manage secrets for the base infra (proxmox keys, k3s token)? For now, I'm just using env vars in the devcontainer
[ ] Configure a backend other than local, probably by deploying a local S3-compatible service (and make sure it's encrypted)
[ ] Deploy GitLab
[ ] need to backup controplane state from laptop

## Testing

[ ] Ensure ssh keys passed to cloud init can be used (and the generated one too, in that case)
[X] does changing the configured host rebuild the vm or simply move it? -> moves it
