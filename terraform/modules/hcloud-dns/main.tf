locals {
  cluster_label = trimsuffix(var.cluster_domain, ".${var.zone_name}")
  etcd_targets  = [for idx in range(length(var.master_private_ips)) : "0 0 2380 etcd-${idx}.${local.cluster_label}.${var.zone_name}"]
}

resource "hcloud_zone" "apex" {
  name = var.zone_name
  mode = "primary"
}

resource "hcloud_zone_rrset" "api" {
  zone    = hcloud_zone.apex.name
  name    = "api.${local.cluster_label}"
  type    = "A"
  ttl     = var.ttl
  records = [{ value = var.lb_private_ip }]
}

resource "hcloud_zone_rrset" "api_int" {
  zone    = hcloud_zone.apex.name
  name    = "api-int.${local.cluster_label}"
  type    = "A"
  ttl     = var.ttl
  records = [{ value = var.lb_private_ip }]
}

resource "hcloud_zone_rrset" "apps" {
  zone    = hcloud_zone.apex.name
  name    = "apps.${local.cluster_label}"
  type    = "A"
  ttl     = var.ttl
  records = [{ value = var.lb_private_ip }]
}

resource "hcloud_zone_rrset" "apps_wildcard" {
  zone    = hcloud_zone.apex.name
  name    = "*.apps.${local.cluster_label}"
  type    = "A"
  ttl     = var.ttl
  records = [{ value = var.lb_private_ip }]
}

resource "hcloud_zone_rrset" "ignition" {
  count   = var.bootstrap_enabled ? 1 : 0
  zone    = hcloud_zone.apex.name
  name    = "ignition.${local.cluster_label}"
  type    = "A"
  ttl     = var.ttl
  records = [{ value = var.ignition_private_ip }]
}

resource "hcloud_zone_rrset" "etcd" {
  for_each = { for idx, ip in var.master_private_ips : idx => ip }

  zone    = hcloud_zone.apex.name
  name    = "etcd-${each.key}.${local.cluster_label}"
  type    = "A"
  ttl     = var.ttl
  records = [{ value = each.value }]
}

resource "hcloud_zone_rrset" "etcd_srv" {
  zone    = hcloud_zone.apex.name
  name    = "_etcd-server-ssl._tcp.${local.cluster_label}"
  type    = "SRV"
  ttl     = var.ttl
  records = [for target in local.etcd_targets : { value = target }]
}
