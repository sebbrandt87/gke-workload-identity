resource "random_string" "bucket" {
  length  = 8
  special = false
  upper   = false
}

resource "google_storage_bucket" "wi-test" {
  name          = join("-", ["wi-test", random_string.bucket.id])
  force_destroy = true
  location      = var.region
  storage_class = "REGIONAL"
  labels = {
    "owner" = var.project
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_service_account" "wi-test" {
  account_id   = "wi-test"
  display_name = "WorkloadIdentity Test"
}

resource "google_storage_bucket_iam_binding" "wi-test" {
  bucket = google_storage_bucket.wi-test.name
  role   = "roles/storage.objectCreator"
  members = [
    join(":", ["serviceAccount", google_service_account.wi-test.email]),
  ]
}
