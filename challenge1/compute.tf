
resource "google_compute_instance" "webserver" {
  for_each = toset(var.instance_name)
  name         = each.key
  machine_type = var.machine
  tags = ["web"]
    labels = {
    environment = "dev"
  }


  boot_disk {
    initialize_params {
      image = var.image_type
      type  = "pd-ssd"
      size  = "20"
    }
  }

 metadata_startup_script = "sudo apt-get update && sudp apt-get install nginx -y && sudo systemctl start nginx"

  network_interface {
    network = google_compute_network.custom-vpc.id
    subnetwork = google_compute_subnetwork.public-subnet.id
    access_config {
      // Ephemeral public IP
    }
    service_account {
    email = "terraform@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  
}
  depends_on = [ google_compute_firewall.web-rule ]
}



  
resource "google_compute_instance" "database" {
  name = var.db
  machine_type = var.machine
  tags = ["db"]
    labels = {
    environment = "dev"
  }
  


  boot_disk {
    initialize_params {
      image = var.image_type
      type  = "pd-ssd"
      size  = "40"
    }
  }

  metadata_startup_script = "sudo apt-get update && sudo apt install mysql-server -y"

  network_interface {
    network = google_compute_network.custom-vpc.id
    subnetwork = google_compute_subnetwork.private-subnet.id
    service_account {
    email = data.google_service_account.svc_tradeedge_linux.email
    scopes = ["cloud-platform"]
  }
  
access_config {
      nat_ip = google_compute_router_nat.nat.id
    }
    service_account {
    email = "terraform@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  
  }
  depends_on = [ google_compute_firewall.backend-rule ]
}




  