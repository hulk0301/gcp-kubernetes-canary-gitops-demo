data "github_repository" "repo" {
  full_name = var.repository
}

resource "github_repository_deploy_key" "write_deploy_key" {
  title      = "Gitops deploy key"
  repository = data.github_repository.repo.name
  key        = var.public_key
  read_only  = "false"
}
