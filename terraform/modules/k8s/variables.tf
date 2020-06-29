variable "location" {
  type        = string
  description = "Location where the cluster will be deployed. Must be either a zone or a region"
  default     = "europe-west4-b"
}

variable "machine_type" {
  type    = string
  default = "n1-standard-1"
}
