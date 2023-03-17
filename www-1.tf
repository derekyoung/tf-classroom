

resource "digitalocean_droplet" "student" {
  count = 4
  image = "ubuntu-22-04-x64"
  name = "student-${count.index}"
  region = "nyc3"
  size = "s-1vcpu-1gb"
  vpc_uuid = digitalocean_vpc.tklft.id
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
