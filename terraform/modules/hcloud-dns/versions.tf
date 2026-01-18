terraform {
  required_providers {
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.1.0"
    }
  }
}

provider "hetznerdns" {
  apitoken = var.hetzner_dns_token
}
