module "ignition" {
  source         = "./modules/hcloud_instance"
  instance_count = var.bootstrap == true ? 1 : 0
  location       = var.location
  name           = "ignition"
  static_ips     = [var.ip_ignition]
  dns_domain     = var.dns_domain
  image          = "ubuntu-22.04"
  user_data      = file("templates/cloud-init.tpl")
  ssh_keys       = data.hcloud_ssh_keys.all_keys.ssh_keys.*.name
  server_type    = var.server_type_ignition
  network_id     = hcloud_network.network.id
  depends_on = [
    module.dns-server
  ]
}

module "dns-server" {
  source         = "./modules/hcloud_instance"
  instance_count = 1
  name           = "dns-server"
  static_ips     = [var.ip_dns_server]
  dns_domain     = var.dns_domain
  image          = "ubuntu-22.04"
  user_data = templatefile("templates/cloud-init-dns.tpl", {
    dns_domain     = var.dns_domain
    apps_ip        = hcloud_load_balancer_network.lb_network.ip
    api_ip         = hcloud_load_balancer_network.lb_network.ip
    api_int_ip     = hcloud_load_balancer_network.lb_network.ip
    ignition_ips   = [var.ip_ignition]
    bootstrap_ips  = [var.ip_bootstrap]
    master_ips     = var.ips_master
    worker_ips     = var.ips_worker
    private_ip     = var.ip_dns_server
    private_iface  = var.dns_private_iface
  })
  ssh_keys       = data.hcloud_ssh_keys.all_keys.ssh_keys.*.name
  server_type    = "cx23"
  network_id     = hcloud_network.network.id
}

locals {
  ignition_private_ip = var.bootstrap == true ? module.ignition.private_ipv4_addresses[0] : null
  ignition_bootstrap_url = var.bootstrap == true ? (
    var.manage_dns ? "http://ignition.${var.dns_domain}/bootstrap.ign" : "http://${local.ignition_private_ip}/bootstrap.ign"
  ) : ""
  ignition_master_url = var.manage_dns ? "https://api-int.${var.dns_domain}:22623/config/master" : "https://${hcloud_load_balancer_network.lb_network.ip}:22623/config/master"
  ignition_worker_url = var.manage_dns ? "https://api-int.${var.dns_domain}:22623/config/worker" : "https://${hcloud_load_balancer_network.lb_network.ip}:22623/config/worker"
}

module "bootstrap" {
  source          = "./modules/hcloud_coreos"
  instance_count  = var.bootstrap == true ? 1 : 0
  location        = var.location
  name            = "bootstrap"
  static_ips      = [var.ip_bootstrap]
  dns_domain      = var.dns_domain
  image           = data.hcloud_image.image.id
  image_name      = var.image
  server_type     = var.server_type_bootstrap
  subnet          = hcloud_network_subnet.subnet.id
  ignition_url    = local.ignition_bootstrap_url
  dns_server_ip   = var.ip_dns_server
  depends_on = [
    module.dns-server
  ]
}

module "master" {
  source          = "./modules/hcloud_coreos"
  instance_count  = var.replicas_master
  location        = var.location
  name            = "master"
  static_ips      = var.ips_master
  dns_domain      = var.dns_domain
  image           = data.hcloud_image.image.id
  image_name      = var.image
  server_type     = var.server_type_master
  labels = {
    "${var.dns_domain}/master"  = "true",
    "${var.dns_domain}/ingress" = "true"
    "cluster"                   = var.dns_domain
  }
  subnet          = hcloud_network_subnet.subnet.id
  ignition_url    = local.ignition_master_url
  ignition_cacert = local.ignition_master_cacert
  dns_server_ip   = var.ip_dns_server
  depends_on = [
    module.dns-server
  ]
}

module "worker" {
  source          = "./modules/hcloud_coreos"
  instance_count  = var.replicas_worker
  location        = var.location
  name            = "worker"
  static_ips      = var.ips_worker
  dns_domain      = var.dns_domain
  image           = data.hcloud_image.image.id
  image_name      = var.image
  server_type     = var.server_type_worker
  labels = {
    "${var.dns_domain}/worker"  = "true"
    "${var.dns_domain}/ingress" = "true"
    "cluster"                   = var.dns_domain
  }
  subnet          = hcloud_network_subnet.subnet.id
  ignition_url    = local.ignition_worker_url
  ignition_cacert = local.ignition_worker_cacert
  dns_server_ip   = var.ip_dns_server
  depends_on = [
    module.dns-server
  ]
}

module "hcloud_dns" {
  count               = var.manage_dns ? 1 : 0
  source              = "./modules/hcloud-dns"
  zone_name           = var.dns_zone_name
  cluster_domain      = var.dns_domain
  lb_private_ip       = hcloud_load_balancer_network.lb_network.ip
  master_private_ips  = module.master.private_ipv4_addresses
  ignition_private_ip = local.ignition_private_ip
  bootstrap_enabled   = var.bootstrap
}
