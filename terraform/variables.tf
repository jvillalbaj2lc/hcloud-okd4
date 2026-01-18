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
  description = "Name of the Cloudflare domain"
}

variable "dns_zone_id" {
  type        = string
  description = "Zone ID of the Cloudflare domain"
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

variable "hetzner_dns_token" {
  type        = string
  description = "Hetzner DNS API token"
}
