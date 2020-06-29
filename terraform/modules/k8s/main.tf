// Dedicated service account used by k8s nodes
resource "google_service_account" "k8s_node" {
  account_id   = "k8s-node"
  display_name = "Kubernetes Node service Account"
}

resource "google_project_iam_member" "k8s_node_log_writer" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.k8s_node.email}"
}

resource "google_project_iam_member" "k8s_node_metric_writer" {
  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.k8s_node.email}"
}

resource "google_project_iam_member" "k8s_node_monitoring_viewer" {
  role   = "roles/monitoring.viewer"
  member = "serviceAccount:${google_service_account.k8s_node.email}"
}

// GKE cluster
resource "google_container_cluster" "cluster" {
  name     = "my-gke-cluster"
  location = var.location

  remove_default_node_pool = true
  initial_node_count       = 1
}

// GKE node pool, preemptible -> to save cost
resource "google_container_node_pool" "preemptible_nodes" {
  name       = "my-node-pool"
  location   = var.location
  cluster    = google_container_cluster.cluster.name
  node_count = 1

  node_config {
    preemptible     = true
    machine_type    = var.machine_type
    service_account = google_service_account.k8s_node.email

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }
}

// Docker registry in EU
resource "google_container_registry" "registry" {
  location = "EU"
}

// IAM permissions to allow cluster to pull images
resource "google_storage_bucket_iam_member" "k8s-image-pull" {
  bucket = google_container_registry.registry.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.k8s_node.email}"
}
