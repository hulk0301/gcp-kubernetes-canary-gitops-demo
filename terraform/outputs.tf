output "lb_ip_address" {
  value = module.dns.lb_ip_address
}

output "lb_url" {
  value = module.dns.lb_url
}

output "registry" {
  value = module.k8s.registry
}
