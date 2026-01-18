resource "cloudflare_dns_record" "dns_a_ignition" {
  zone_id = var.dns_zone_id
  name    = "ignition.${var.dns_domain}"
  content = module.ignition.ipv4_addresses[0]
  type    = "A"
  ttl     = 120
  count   = var.bootstrap == true ? 1 : 0
}

resource "cloudflare_dns_record" "dns_a_api" {
  zone_id = var.dns_zone_id
  name    = "api.${var.dns_domain}"
  content = hcloud_load_balancer.lb.ipv4
  type    = "A"
  ttl     = 120
}

resource "cloudflare_dns_record" "dns_a_apps" {
  zone_id = var.dns_zone_id
  name    = "apps.${var.dns_domain}"
  content = hcloud_load_balancer.lb.ipv4
  type    = "A"
  ttl     = 120
}

resource "cloudflare_dns_record" "dns_a_apps_wc" {
  zone_id = var.dns_zone_id
  name    = "*.apps.${var.dns_domain}"
  content = hcloud_load_balancer.lb.ipv4
  type    = "A"
  ttl     = 120
}
