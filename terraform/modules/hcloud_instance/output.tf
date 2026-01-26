output "server_ids" {
  value = [for s in hcloud_server.server : s.id]
}

output "server_names" {
  value = [for s in hcloud_server.server : s.name]
}

#output "internal_ipv4_addresses" {
#  value = hcloud_server_network.server_network.*.ip
#}

output "ipv4_addresses" {
  value = [for s in hcloud_server.server : s.ipv4_address]
}

output "ipv6_addresses" {
  value = [for s in hcloud_server.server : s.ipv6_address]
}

output "private_ipv4_addresses" {
  value = [for s in hcloud_server.server : s.network[0].ip if length(s.network) > 0]
}
