#cloud-config
package_update: true
packages:
  - dnsmasq

write_files:
  - path: /etc/dnsmasq.conf
    content: |
      # Main dnsmasq config
      conf-dir=/etc/dnsmasq.d,*.conf
      bind-interfaces
      interface=${private_iface}
      listen-address=127.0.0.1,${private_ip}
      except-interface=eth0
      # (Optional hardening)
      domain-needed
      bogus-priv
      cache-size=1000

  - path: /etc/dnsmasq.d/01-hetzner-okd.conf
    content: |
      # Avoid reading /etc/resolv.conf (prevents loops if resolv.conf points to 127.0.0.1)
      no-resolv

      # Upstream resolvers
      server=1.1.1.1
      server=1.0.0.1

      # OKD static records
      address=/apps.${dns_domain}/${apps_ip}
      address=/api.${dns_domain}/${api_ip}
      address=/api-int.${dns_domain}/${api_int_ip}

      %{ for idx, ip in ignition_ips ~}
      address=/ignition${format("%02d", idx+1)}.${dns_domain}/${ip}
      %{ endfor ~}
      %{ if length(ignition_ips) > 0 ~}
      address=/ignition.${dns_domain}/${ignition_ips[0]}
      %{ endif ~}

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
  - systemctl disable --now systemd-resolved || true
  - pkill -f systemd-resolved || true
  - rm -f /etc/resolv.conf
  - printf "nameserver 127.0.0.1\n" > /etc/resolv.conf
  - systemctl enable dnsmasq
  - systemctl restart dnsmasq
  - systemctl --no-pager --full status dnsmasq || true
