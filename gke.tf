locals {
  network_cidr = "10.2.0.0/16"
  master_cidr  = "10.42.0.240/28"
  service_cidr = "192.168.1.0/24"
  pod_cidr     = "192.168.64.0/22"
}

resource "google_compute_network" "gke" {
  name                    = "gke-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke" {
  name                     = "gke-subnet"
  ip_cidr_range            = local.network_cidr
  region                   = var.region
  network                  = google_compute_network.gke.id
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = local.service_cidr
  }

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = local.pod_cidr
  }
}

resource "google_container_cluster" "gke-wi-poc" {
  name               = "gke-wi-poc"
  location           = var.region
  initial_node_count = 1

  network    = google_compute_network.gke.id
  subnetwork = google_compute_subnetwork.gke.id

  enable_autopilot = var.enable_autopilot

  private_cluster_config {
    enable_private_nodes    = true
    master_ipv4_cidr_block  = local.master_cidr
    enable_private_endpoint = false
    master_global_access_config {
      enabled = true
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = join("/", tolist([chomp(data.http.icanhazip.body), "32"]))
      display_name = "my-isp-assigned-ip"
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "services-range"
    services_secondary_range_name = google_compute_subnetwork.gke.secondary_ip_range.1.range_name
  }

  vertical_pod_autoscaling {
    enabled = true
  }
}
