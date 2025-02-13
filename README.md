## TODO

- update this README
- override .env defaults: https://docs.docker.com/compose/how-tos/environment-variables/variable-interpolation/#local-env-file-versus-project-directory-env-file
- split up services so it's easier to manage them individually
- improve -arr docker setup: https://wiki.servarr.com/docker-guide#Consistent_and_well_planned_paths
- split up iGPU and pass through
- subtitles
- split up series and anime (maybe use separate sonarr instances)
- backup configs
- seed ratios / auto delete
- split up 'front' and 'back' services?
- 'default/base' config + overwrite with config dir
- switch to traefik (I think it makes proxy config more explicit)
- use real storage for authelia
- pin container versions
- replace mail.buen.ga sending address with just buen.ga?

- Add 2nd dns server
- ssh-agent doesn't (always?) auto-start, but persists across logouts. Switching to Gnome messes everything up bc it starts Gnome's keyring. Also, for some reason you need to push something locally before the ssh key can be used within a container to push

### WIP

- Caddy
- Secrets store?
- docker permissions (UIDs & GIDs)

## Tips

- Ensure you install docker directly from source (no snap, no bundled with OS)

## Providers

- Mailgun: SMTP
- Cloudflare: DNS
