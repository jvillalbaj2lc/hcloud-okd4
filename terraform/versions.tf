terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.9.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.52.0" # Upgrade to latest
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
  required_version = ">= 0.14"
}
