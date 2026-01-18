variable "dns_domain" {
  type        = string
  description = "Name of the Hetzner DNS zone"
}

variable "ignition_ip" {
  type        = string
  description = "IP address of the ignition server"
  default = ""
}

variable "load_balancer_ip" {
  type        = string
  description = "IP address of the load balancer"
}

variable "master_ips" {
  type        = list(string)
  description = "List of IP addresses of the master nodes"
}

variable "bootstrap" {
  type        = bool
  description = "Whether to deploy a bootstrap instance"
}

variable "hetzner_dns_token" {
  type        = string
  description = "Hetzner DNS API token"
}
