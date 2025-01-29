provider "google" {
  project = "ferrous-upgrade-446608-k0"
  region  = "us-east1"
  zone    = "us-east1-a"
}

resource "google_compute_instance" "jenkins_vm" {
  name         = "jenkins-vm"
  machine_type = "e2-medium"
  zone         = "us-east1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"  # Use Debian 11 image
    }
  }

  network_interface {
    network = "default"
    access_config {}  # Enables external IP
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx git
    sudo systemctl start nginx
    sudo systemctl enable nginx
    git clone https://github.com/reethuo/gcpTfJenkins.git /var/www/html/
  EOF

  tags = ["web-server"]
}

output "instance_ip" {
  value = google_compute_instance.jenkins_vm.network_interface[0].access_config[0].nat_ip
}
