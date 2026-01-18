locals {
  hcloud_arch = var.arch == "arm64" ? "arm" : "x86"
}

data "hcloud_image" "image" {
  with_selector     = "os=${var.image},arch=${var.arch}"
  with_architecture = local.hcloud_arch
  with_status       = ["available"]
  most_recent       = true
}
