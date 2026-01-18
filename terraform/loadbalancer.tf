locals {
  # Une todos los servers que deben ser targets del LB (masters + workers + bootstrap)
  # Usa claves estáticas para evitar for_each con valores desconocidos en plan
  lb_target_servers_master = {
    for idx in range(var.replicas_master) :
    "master-${idx}" => module.master.server_ids[idx]
  }

  lb_target_servers_worker = {
    for idx in range(var.replicas_worker) :
    "worker-${idx}" => module.worker.server_ids[idx]
  }

  lb_target_servers_bootstrap = var.bootstrap ? {
    "bootstrap-0" = module.bootstrap.server_ids[0]
  } : {}

  lb_target_server_ids = merge(
    local.lb_target_servers_master,
    local.lb_target_servers_worker,
    local.lb_target_servers_bootstrap
  )
}

resource "hcloud_load_balancer" "lb" {
  name               = "lb.${var.dns_domain}"
  load_balancer_type = "lb11"
  location           = var.location
}

resource "hcloud_load_balancer_network" "lb_network" {
  load_balancer_id = hcloud_load_balancer.lb.id
  subnet_id        = hcloud_network_subnet.lb_subnet.id

  # Debe estar dentro de 192.168.253.0/24 (tu lb_subnet)
  ip = "192.168.253.254"
}

resource "hcloud_load_balancer_target" "servers" {
  for_each         = local.lb_target_server_ids
  type             = "server"
  load_balancer_id = hcloud_load_balancer.lb.id
  server_id        = each.value
  use_private_ip   = true

  depends_on = [
    hcloud_load_balancer_network.lb_network,
    module.bootstrap,
    module.master,
    module.worker,
  ]
}

resource "hcloud_load_balancer_service" "lb_api" {
  load_balancer_id = hcloud_load_balancer.lb.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

resource "hcloud_load_balancer_service" "lb_mcs" {
  load_balancer_id = hcloud_load_balancer.lb.id
  protocol         = "tcp"
  listen_port      = 22623
  destination_port = 22623
}

resource "hcloud_load_balancer_service" "lb_ingress_http" {
  load_balancer_id = hcloud_load_balancer.lb.id
  protocol         = "tcp"
  listen_port      = 80
  destination_port = 80
}

resource "hcloud_load_balancer_service" "lb_ingress_https" {
  load_balancer_id = hcloud_load_balancer.lb.id
  protocol         = "tcp"
  listen_port      = 443
  destination_port = 443
}
