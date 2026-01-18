locals {
  # Une todos los servers que deben ser targets del LB (masters + workers + bootstrap)
  lb_target_server_ids = toset(concat(
    module.master.server_ids,
    module.worker.server_ids,
    module.bootstrap.server_ids
  ))
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

  depends_on = [hcloud_load_balancer_network.lb_network]
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
