## TODO

- update this README
- override .env defaults: https://docs.docker.com/compose/how-tos/environment-variables/variable-interpolation/#local-env-file-versus-project-directory-env-file
- improve -arr docker setup: https://wiki.servarr.com/docker-guide#Consistent_and_well_planned_paths
- split up iGPU and pass through
- subtitles
- split up series and anime (maybe use separate sonarr instances)
- backup configs
- seed ratios / auto delete
- split up 'front' and 'back' services?
- 'default/base' config + overwrite with config dir
- use real storage for authelia
- pin container versions
- replace mail.buen.ga sending address with just buen.ga?
- docker permissions (make UIDs & GIDs within containers match local users)

- Add 2nd dns server
- Secrets store?
- ssh-agent doesn't (always?) auto-start, but persists across logouts. Switching to Gnome messes everything up bc it starts Gnome's keyring. Also, for some reason you need to push something locally before the ssh key can be used within a container to push

## Plan

- Set up VMs for K8s cluster

## Proxmox node setup

This needs to be run on each node.

As root:

```
apt install sudo
adduser buengabacho
```

Fill out the required fields, then run `adduser buengabacho sudo` to add root privileges.

As buengabacho:

Run `sudo visudo -f /etc/sudoers.d/passwordless-sudo` and paste the following:

```
# Allow buengabacho to run sudo without a password
buengabacho ALL=(ALL:ALL) NOPASSWD:ALL
```

Run `sudo nano /etc/ssh/sshd_config` and set `PasswordAuthentication no`. Afterwards, restart SSH by running `sudo systemctl restart ssh`

Finally, in the Proxmox console, add buengabacho as a PAM user under 'Datacenter' -> 'Users' (ensure to add the 'admin' group), and disable the root user so it can't be used to log in.

## Tips

- Ensure you install docker directly from source (no snap, no bundled with OS)

## Providers

- Mailgun: SMTP
- Cloudflare: DNS
