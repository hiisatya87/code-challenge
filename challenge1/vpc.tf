# Custom VPC
resource "google_compute_network" "custom-vpc" {
  name                    = "custom-vpc"
  auto_create_subnetworks = false
}

# Public Subnet

resource "google_compute_subnetwork" "public-subnet" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.10.0/24"
  region        = "us-east1"
  network       = google_compute_network.custom-vpc.id
}

# Private Subnet

resource "google_compute_subnetwork" "private-subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.11.0.0/24"
  region        = "us-east1"
  network       = google_compute_network.custom-vpc.id
}

# Cloud Router

resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.custom-vpc.id
  bgp {
    asn            = 64514
    advertise_mode = "CUSTOM"
  }
}

# NAT Gateway
resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = "private-subnet"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

#creating Firewall rule
resource "google_compute_firewall" "web-rule" {
  name    = "web-rule"
  network = google_compute_network.custom-vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80","443","22"]
  }
  source_ranges  = ["0.0.0.0/0"]
  target_tags = ["web"]
}

resource "google_compute_firewall" "backend-rule" {
  name    = "backend-rule"
  network = google_compute_network.custom-vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["1000-4000","22"]
  }

  target_tags = ["db"]

}

