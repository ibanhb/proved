terraform {
  required_version = ">=1.5.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.74.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25.2"
    }
  }
}

/* ls- l */

provider "kubernetes" {
  required_version = ">=2.25.2"
  load_config_file = "false"

  host = google_container_cluster.primary.endpoint
  token   = data.google_client_config.current.access_token
  client_certificate = base64decode(
    google_container_cluster.default.master_auth[0].client_certificate,
  )
  client_key = base64decode(google_container_cluster.default.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(
    google_container_cluster.default.master_auth[0].cluster_ca_certificate,
  )
}