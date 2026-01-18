
resource "hcloud_zone" "private_zone" {
  name = var.dns_domain
  ttl  = 120
  mode = "primary"
}

resource "hcloud_zone_rrset" "api" {
  zone    = hcloud_zone.private_zone.name
  type    = "A"
  name    = "api"
  records = [{ value = hcloud_load_balancer_network.lb_network.ip }]
  ttl     = 120
}

resource "hcloud_zone_rrset" "api_int" {
  zone    = hcloud_zone.private_zone.name
  type    = "A"
  name    = "api-int"
  records = [{ value = hcloud_load_balancer_network.lb_network.ip }]
  ttl     = 120
}

resource "hcloud_zone_rrset" "etcd" {
  for_each = {
    for i, ip in module.master.internal_ipv4_addresses : i => ip
  }
  zone    = hcloud_zone.private_zone.name
  type    = "A"
  name    = "etcd-${each.key}"
  records = [{ value = each.value }]
  ttl     = 120
}

resource "hcloud_zone_rrset" "etcd_srv" {
  zone    = hcloud_zone.private_zone.name
  type    = "SRV"
  name    = "_etcd-server-ssl._tcp"
  records = [
    for i in range(var.replicas_master) : { value = "0 0 2380 etcd-${i}.${var.dns_domain}" }
  ]
  ttl = 120
}
