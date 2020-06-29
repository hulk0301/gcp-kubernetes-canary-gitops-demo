variable "project" {
  type        = string
  description = "GCP project id"
}

variable "location" {
  type        = string
  description = "Location where the cluster will be deployed. Must be either a zone or a region"
  default     = "europe-west4-b"
}

variable "machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "git_repository" {
  type        = string
  description = "Full name of the Gitops GitHub repository"
}

variable "git_path" {
  type        = string
  description = "One or more paths within git repo to locate Kubernetes manifests (relative path(s))"
  default     = ""
}

variable "git_branch" {
  type    = string
  default = "master"
}

variable "dns_zone" {
  type        = string
  description = "ID of the managed DNS zone. Must be existing."
}
