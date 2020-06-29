data "google_client_config" "default" {}

provider "github" {
  organization = "hulk0301"
}

provider "google" {
  project = var.project
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    cluster_ca_certificate = base64decode(module.k8s.cluster_ca_certificate)
    host                   = module.k8s.endpoint
    token                  = data.google_client_config.default.access_token
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(module.k8s.cluster_ca_certificate)
  host                   = module.k8s.endpoint
  token                  = data.google_client_config.default.access_token
}

module "k8s" {
  source = "./modules/k8s"

  location     = var.location
  machine_type = var.machine_type
}

module "flux" {
  source = "./modules/flux"

  git_url    = module.git.git_clone_url
  git_branch = var.git_branch
  git_path   = var.git_path
}

module "git" {
  source = "./modules/git"

  repository = var.git_repository
  public_key = module.flux.git_public_key
}

module "dns" {
  source = "./modules/dns"

  dns_zone = var.dns_zone
}
