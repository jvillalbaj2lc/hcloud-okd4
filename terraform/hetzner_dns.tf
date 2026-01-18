
resource "hetznerdns_zone" "private_zone" {
  name = var.dns_domain
  ttl  = 3600
}

resource "hetznerdns_record" "master" {
  count   = var.replicas_master
  zone_id = hetznerdns_zone.private_zone.id
  name    = "master-${count.index}"
  type    = "A"
  value   = module.master.internal_ipv4_addresses[count.index]
  ttl     = 120
}

resource "hetznerdns_record" "etcd" {
  count   = var.replicas_master
  zone_id = hetznerdns_zone.private_zone.id
  name    = "etcd-${count.index}"
  type    = "A"
  value   = module.master.internal_ipv4_addresses[count.index]
  ttl     = 120
}

resource "hetznerdns_record" "etcd_srv" {
  count   = var.replicas_master
  zone_id = hetznerdns_zone.private_zone.id
  name    = "_etcd-server-ssl._tcp"
  type    = "SRV"
  value   = "0 0 2380 etcd-${count.index}.${var.dns_domain}"
  ttl     = 120
}

resource "hetznerdns_record" "api" {
  zone_id = hetznerdns_zone.private_zone.id
  name    = "api"
  type    = "A"
  value   = hcloud_load_balancer_network.lb_network.ip
  ttl     = 120
}

resource "hetznerdns_record" "api_int" {
  zone_id = hetznerdns_zone.private_zone.id
  name    = "api-int"
  type    = "A"
  value   = hcloud_load_balancer_network.lb_network.ip
  ttl     = 120
}
