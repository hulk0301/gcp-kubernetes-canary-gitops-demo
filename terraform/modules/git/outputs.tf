output "git_clone_url" {
    value = "git@github.com:${data.github_repository.repo.full_name}"
}
