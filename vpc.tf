resource "digitalocean_vpc" "lft458" {
  name     = "lfc458-sfo3"
  region   = "sfo3"
  ip_range = "10.128.0.0/24"
}
