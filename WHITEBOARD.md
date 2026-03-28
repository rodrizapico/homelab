# NixOS setup from template

The CloudInit user is used for instance management (terraform generates a SSH key pair and uses that to update the instance as needed). Any users you want to use on the deployed instance should be set up statically in the nix config.

# Create/refresh/destroy component in stage

`atmos terraform [apply|refresh|destroy] COMPONENT -s STAGE`

For example: `atmos terraform apply devpod -s controlplane`

# Monkeypatch for nix-build.sh

`nix-build.sh` is found in `.terraform/modules/deploy/terraform/nix-build` for the terraform component that uses the nixos-anywhere module. Here's a link to the necessary changes: https://github.com/nix-community/nixos-anywhere/issues/491#issuecomment-3962993035.

# Temporarily install some program in a virtual env for testing

`nix-shell -p [your_program_here]`

# Check logs for a service

`journalctl -u [your_service_here]`

use `-e` to start at the end of the logs.
use `--no-pager | grep "[your_keyword_here]"` to look for a specific keyword

# Fix missing atmos/terraform/npins/etc after rebuild:

You need to remove the nix volume before rebuilding.
