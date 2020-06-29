output "git_public_key" {
  value = tls_private_key.flux.public_key_openssh
}
