# modulo Bastion

module "iap_bastion" {
  source  = "terraform-google-modules/bastion-host/google"
  project = var.project_id
  zone    = "us-west1-a"
  network = google_compute_network.network.self_link
  subnet  = google_compute_subnetwork.subnet.self_link
  members = var.members
  disk_labels = {
    "test-label" = "test-value"
  }

}

resource "google_compute_network" "network" {
  project                 = var.project_id
  name                    = "vpc-nonprod-shared"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  project                  = var.project_id
  name                     = "internet-stg-network"
  region                   = "us-east1"
  ip_cidr_range            = "10.2.1.0/30"
  network                  = google_compute_network.network.self_link
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_access_from_bastion" {
  project = var.project_id
  name    = "allow-bastion-ssh"
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Allow SSH only from IAP Bastion
  source_service_accounts = [module.iap_bastion.service_account]
}