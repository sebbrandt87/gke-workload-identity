output "bucket" {
  value = google_storage_bucket.wi-test.name
}

output "cluster" {
  value = google_container_cluster.gke-wi-poc.name
}

output "location" {
  value = google_container_cluster.gke-wi-poc.location
}
