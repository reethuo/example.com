provider "google" {
  project = "ferrous-upgrade-446608-k0"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "jenkins_vm" {
  name         = "jenkins-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-c"

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
    git clone https://github.com/reethuo/example.com.git /var/www/html/
  EOF

  tags = ["web-server"]
}

output "instance_ip" {
  value = google_compute_instance.jenkins_vm.network_interface[0].access_config[0].nat_ip
}
