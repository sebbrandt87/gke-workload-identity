locals {
  k8s_namespace      = "wi-test"
  k8s_serviceaccount = "wi-test"
}

resource "google_service_account_iam_member" "wi-test" {
  service_account_id = google_service_account.wi-test.name
  role               = "roles/iam.workloadIdentityUser"
  member             = join(":", ["serviceAccount", format("%s.svc.id.goog[%s/%s]", var.project, local.k8s_namespace, local.k8s_serviceaccount)])
}
