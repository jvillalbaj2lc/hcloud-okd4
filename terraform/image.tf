data "hcloud_image" "image" {
  with_selector = "os=${var.image},arch=${var.arch}"
  with_architecture = "arm"
  with_status   = ["available"]
  most_recent   = true
}
