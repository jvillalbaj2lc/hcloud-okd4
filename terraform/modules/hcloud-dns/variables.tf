variable "zone_name" {
  type        = string
  description = "Apex DNS zone name (example.com)"
}

variable "cluster_domain" {
  type        = string
  description = "Cluster domain (okd4.example.com)"

  validation {
    condition = var.cluster_domain != var.zone_name && can(regex("\\.${replace(var.zone_name, ".", "\\.")}$", var.cluster_domain))
    error_message = "cluster_domain must be a subdomain of zone_name (e.g. okd4.example.com when zone_name is example.com)."
  }
}

variable "lb_private_ip" {
  type        = string
  description = "Private IP address of the load balancer"
}

variable "master_private_ips" {
  type        = list(string)
  description = "Private IPv4 addresses of the control plane nodes"
}

variable "ignition_private_ip" {
  type        = string
  description = "Private IPv4 address of the ignition host"
  default     = null
}

variable "bootstrap_enabled" {
  type        = bool
  description = "Whether bootstrap resources (ignition) are enabled"
  default     = false

  validation {
    condition     = var.bootstrap_enabled == false || var.ignition_private_ip != null
    error_message = "ignition_private_ip must be set when bootstrap_enabled is true."
  }
}

variable "ttl" {
  type        = number
  description = "TTL for DNS records"
  default     = 120
}
