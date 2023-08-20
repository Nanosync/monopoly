resource "google_service_account" "service_account" {
  account_id   = "monopoly"
  display_name = "Monopoly"
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name          = "monopoly-${random_id.bucket_prefix.hex}"
  location      = "US"
  storage_class = "STANDARD"
}

resource "google_artifact_registry_repository" "default" {
  location      = "us-central1"
  repository_id = "monopoly"
  format        = "DOCKER"
}

resource "google_secret_manager_secret_iam_binding" "default" {
  secret_id = data.google_secret_manager_secret_version.default.secret
  project   = data.google_secret_manager_secret_version.default.project
  role      = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}
