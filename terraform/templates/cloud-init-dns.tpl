#cloud-config
packages:
  - dnsmasq

write_files:
  - path: /etc/dnsmasq.d/01-hetzner-okd.conf
    content: |
      server=1.1.1.1
      server=1.0.0.1
      address=/apps.${dns_domain}/${apps_ip}
      address=/api.${dns_domain}/${api_ip}
      address=/api-int.${dns_domain}/${api_int_ip}
      %{ for ip in ignition_ips ~}
      address=/ignition.${dns_domain}/${ip}
      %{ endfor ~}
      %{ for idx, ip in bootstrap_ips ~}
      address=/bootstrap${format("%02d", idx+1)}.${dns_domain}/${ip}
      %{ endfor ~}
      %{ for idx, ip in master_ips ~}
      address=/master${format("%02d", idx+1)}.${dns_domain}/${ip}
      %{ endfor ~}
      %{ for idx, ip in worker_ips ~}
      address=/worker${format("%02d", idx+1)}.${dns_domain}/${ip}
      %{ endfor ~}

runcmd:
  - systemctl enable dnsmasq
  - systemctl restart dnsmasq
