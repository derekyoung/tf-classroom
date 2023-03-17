resource "digitalocean_vpc" "tklft" {
  name     = "lfc458-network"
  region   = "nyc3"
  ip_range = "10.128.0.0/24"
}
