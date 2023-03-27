

resource "digitalocean_droplet" "student" {
  count = 6
  image = "ubuntu-22-04-x64"
  name = "student-00${count.index}"
  region = "sfo3"
  size = "s-1vcpu-1gb"
  vpc_uuid = digitalocean_vpc.lft458.id
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "useradd --create-home --shell /bin/bash --groups sudo student",
      "mkdir -p /home/student/.ssh",
      "cp /root/.ssh/authorized_keys /home/student/.ssh",
      "chmod 600 /home/student/.ssh/authorized_keys",
      "chmod 700 /home/student/.ssh",
      "chown -R student:student /home/student/.ssh",
      "echo 'student ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/95-student"
    ]
  }
}

output "droplet_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.student:
    droplet.name => droplet.ipv4_address
  }
}
output "droplet_ip_addresses_private" {
  value = {
    for droplet in digitalocean_droplet.student:
    droplet.name => droplet.ipv4_address_private
  }
}

