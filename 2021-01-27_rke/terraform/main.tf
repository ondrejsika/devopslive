data "digitalocean_ssh_key" "main" {
  name = var.ssh_key_name
}

module "rke0" {
  source     = "./modules/rke-nodes-and-lb"
  ssh_key    = data.digitalocean_ssh_key.main
  cluster_no = 0
  node_count = 3
}

module "rke1" {
  source     = "./modules/rke-nodes-and-lb"
  ssh_key    = data.digitalocean_ssh_key.main
  cluster_no = 1
  node_count = 6
}

module "rke2" {
  source     = "./modules/rke-nodes-and-lb"
  ssh_key    = data.digitalocean_ssh_key.main
  cluster_no = 2
  node_count = 3
}
