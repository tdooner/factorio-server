resource "digitalocean_ssh_key" "factorio" {
  name = "DigitalOcean Terraform"
  public_key = "${file("~/.ssh/factorio_rsa.pub")}"
}

resource "digitalocean_droplet" "factorio-server" {
  image = "ubuntu-16-04-x64"
  name = "factorio"
  region = "sfo1"
  size = "512mb"
  ssh_keys = ["${digitalocean_ssh_key.factorio.fingerprint}"]

  connection {
    type = "ssh"
    private_key = "${file("~/.ssh/factorio_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
    "wget -qO /tmp/chef.deb https://packages.chef.io/stable/ubuntu/12.04/chef_12.12.15-1_amd64.deb",
    "dpkg -i /tmp/chef.deb",
    ]
  }

  provisioner "local-exec" {
    command = "./run-chef.sh ${digitalocean_droplet.factorio-server.ipv4_address}"
  }
}

resource "cloudflare_record" "factorio" {
  domain = "tdooner.com"
  name = "factorio"
  value = "${digitalocean_droplet.factorio-server.ipv4_address}"
  type = "A"
  ttl = 120
}

output "ip_address" {
  value = "${digitalocean_droplet.factorio-server.ipv4_address}"
}
