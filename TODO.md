# TODO

[X] Update devpod configuration to include docker and remove unnecessary deps
[X] Check if partition grows automatically
[X] Test running in devpod, remove manually created one
[X] autostart vms on boot
[ ] create k3s terraform component with configurable amount of nodes / distribute across hosts
[ ] how do I manage secrets for the base infra (proxmox keys, k3s token)? For now, I'm just using env vars in the devcontainer
[ ] test if changing the configured host rebuilds the vm or simply moves it
[ ] Configure a backend other than local, probably by deploying a local S3-compatible service (and make sure it's encrypted)
[ ] Deploy GitLab
[ ] need to backup controplane state from laptop
