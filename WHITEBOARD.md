# NixOS setup from template

The CloudInit user is used for instance management (terraform generates a SSH key pair and uses that to update the instance as needed). Any users you want to use on the deployed instance should be set up statically in the nix config.

# Create devpod in controlplane

atmos terraform apply devpod -s controlplane

# Destroy devpod in controlplane

atmos terraform destroy devpod -s controlplane

# Monkeypatch for nix-build.sh

`nix-build.sh` is found in `.terraform/modules/deploy/terraform/nix-build` for the terraform component that uses the nixos-anywhere module. Here's a link to the necessary changes: https://github.com/nix-community/nixos-anywhere/issues/491#issuecomment-3962993035.
