resource "google_compute_instance" "myapp1" {
  name         = "myapp1"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = [
    tolist(google_compute_firewall.fw_ssh.target_tags)[0], #tolist is a function
    tolist(google_compute_firewall.fw_http.target_tags)[0]
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  # Convert Windows CRLF to Linux LF before sending the script to GCP.
  metadata_startup_script = replace(
    file("${path.module}/app1-webserver-install.sh"),
    "\r\n",
    "\n"
  )

  network_interface {
    subnetwork = google_compute_subnetwork.mysubnet.id

    access_config {
      # Assign an external IP address.
    }
  }
}