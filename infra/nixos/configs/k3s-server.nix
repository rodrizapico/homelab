{ config, pkgs, lib, terraform, ... }:
let
  k3sClusterInit  = (terraform.options.k3s_cluster_init or "false") == "true";
  k3sClusterToken = terraform.options.k3s_cluster_token;
  k3sServerAddr   = terraform.options.k3s_server_addr or "";
in {
  imports = [ ./base ];

  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];

  services.k3s = {
    enable      = true;
    role        = "server";
    clusterInit = k3sClusterInit;
    token       = k3sClusterToken;
    serverAddr  = k3sServerAddr;
  };
}
