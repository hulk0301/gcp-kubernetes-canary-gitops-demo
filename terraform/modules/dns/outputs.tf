output "lb_ip_address" {
  value = google_compute_global_address.lb_ip_address.address
}

output "lb_url" {
  value = "https://${google_dns_record_set.lb.name}"
}
