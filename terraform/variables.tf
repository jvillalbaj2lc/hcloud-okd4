variable "replicas_master" {
  type        = number
  default     = 1
  description = "Count of master replicas"
}

variable "replicas_worker" {
  type        = number
  default     = 0
  description = "Count of worker replicas"
}

variable "bootstrap" {
  type        = bool
  default     = false
  description = "Whether to deploy a bootstrap instance"
}

variable "dns_domain" {
  type        = string
  description = "Cluster domain (e.g. okd4.example.com)"
}

variable "manage_dns" {
  type        = bool
  description = "Whether to manage DNS records via Hetzner DNS"
  default     = false
}

variable "dns_zone_name" {
  type        = string
  description = "Apex DNS zone name (e.g. example.com)"
  default     = null

  validation {
    condition     = var.manage_dns == false || (var.dns_zone_name != null && var.dns_zone_name != "")
    error_message = "dns_zone_name must be set when manage_dns is true."
  }
}

variable "ip_loadbalancer_api" {
  description = "IP of an external loadbalancer for api (optional)"
  default     = null
}

variable "ip_loadbalancer_api_int" {
  description = "IP of an external loadbalancer for api-int (optional)"
  default     = null
}

variable "ip_loadbalancer_apps" {
  description = "IP of an external loadbalancer for apps (optional)"
  default     = null
}

variable "ip_dns_server" {
  type        = string
  description = "IP of the internal DNS server"
  default     = "192.168.254.4"
}

variable "network_cidr" {
  type        = string
  description = "CIDR for the network"
  default     = "192.168.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR for the subnet"
  default     = "192.168.254.0/24"
}

variable "lb_subnet_cidr" {
  type        = string
  description = "CIDR for the loadbalancer subnet"
  default     = "192.168.253.0/24"
}

variable "location" {
  type        = string
  description = "Region"
  default     = "nbg1"
}

variable "image" {
  type        = string
  description = "Image selector (either fcos or rhcos)"
  default     = "fcos"
}

variable "arch" {
  type        = string
  description = "CPU architecture for image selection (amd64 or arm64)"
  default     = "amd64"
}

variable "server_type_ignition" {
  type        = string
  description = "Hetzner server type for the ignition host"
  default     = "cpx21"
}

variable "server_type_bootstrap" {
  type        = string
  description = "Hetzner server type for the bootstrap host"
  default     = "cpx41"
}

variable "server_type_master" {
  type        = string
  description = "Hetzner server type for master nodes"
  default     = "cpx41"
}

variable "server_type_worker" {
  type        = string
  description = "Hetzner server type for worker nodes"
  default     = "cpx41"
}
