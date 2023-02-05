provider "rke" {
  log_file = "rke_debug.log"
}

resource "rke_cluster" "rke2" {
  cluster_name   = "rke2"
  ssh_agent_auth = true
  nodes {
    address = "rke2no0.sikademo.com"
    user    = "root"
    role    = ["controlplane", "worker", "etcd"]
  }
  nodes {
    address = "rke2no1.sikademo.com"
    user    = "root"
    role    = ["controlplane", "worker", "etcd"]
  }
  nodes {
    address = "rke2no2.sikademo.com"
    user    = "root"
    role    = ["controlplane", "worker", "etcd"]
  }
}

output "kubeconfig" {
  value     = rke_cluster.rke2.kube_config_yaml
  sensitive = true
}
