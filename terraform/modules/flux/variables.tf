variable "git_url" {
  type        = string
}

variable "git_path" {
  type        = string
  description = "One or more paths within git repo to locate Kubernetes manifests (relative path(s))"
  default     = ""
}

variable "git_branch" {
  type        = string
  default     = "master"
}
