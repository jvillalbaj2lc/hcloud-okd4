resource "hcloud_server_network" "server_network" {
  count     = var.instance_count
  server_id = element(hcloud_server.server.*.id, count.index)
  subnet_id = var.subnet
  ip        = length(var.static_ips) > 0 ? var.static_ips[count.index] : null
}
