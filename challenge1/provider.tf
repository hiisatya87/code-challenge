
provider "google" {
  credentials = file("gcp-account.json")
  project     = "var.project_id"
  region      = "var.project_region"
  zone        = "var.project_zone"
}


