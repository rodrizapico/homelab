# Create devpod in controlplane

atmos terraform apply devpod -s controlplane

# Destroy devpod in controlplane

atmos terraform destroy devpod -s controlplane

# Monkeypatch for nix-build.sh

`nix-build.sh` is found in `.terraform/modules/deploy/terraform/nix-build` for the terraform component that uses the nixos-anywhere module. Here's a link to the necessary changes: https://github.com/nix-community/nixos-anywhere/issues/491#issuecomment-3962993035.
