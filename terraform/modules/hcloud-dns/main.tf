resource "hetznerdns_zone" "zone" {
  name = var.dns_domain
  ttl  = 3600
}

resource "hetznerdns_record" "dns_a_ignition" {
  zone_id = hetznerdns_zone.zone.id
  name    = "ignition"
  value   = var.ignition_ip
  type    = "A"
  ttl     = 120
  count   = var.bootstrap == true ? 1 : 0
}

resource "hetznerdns_record" "dns_a_api_int" {
  zone_id = hetznerdns_zone.zone.id
  name    = "api-int"
  value   = var.load_balancer_ip
  type    = "A"
  ttl     = 120
}

resource "hetznerdns_record" "dns_a_etcd" {
  zone_id = hetznerdns_zone.zone.id
  name    = "etcd-${count.index}"
  value   = var.master_ips[count.index]
  type    = "A"
  ttl     = 120
  count   = length(var.master_ips)
}

resource "hetznerdns_record" "dns_srv_etcd" {
  zone_id = hetznerdns_zone.zone.id
  name    = "_etcd-server-ssl._tcp"
  type    = "SRV"
  ttl     = 120
  value   = "0 0 2380 etcd-${count.index}.${hetznerdns_zone.zone.name}"
  count   = length(var.master_ips)
}
