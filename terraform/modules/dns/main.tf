// Already existing in my test project
data "google_dns_managed_zone" "dns_zone" {
  name = var.dns_zone
}

// IP address used by the Loadbalancer on GKE, will be referenced via name
resource "google_compute_global_address" "lb_ip_address" {
  name = "lb-ip-address"
}

// A record for demo purpose
resource "google_dns_record_set" "lb" {
  name = "lb.demo.${data.google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.dns_zone.name
  rrdatas      = [google_compute_global_address.lb_ip_address.address]
}
