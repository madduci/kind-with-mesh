# Pulls the image
resource "docker_image" "cloud_controller_manager" {
  name = "registry.k8s.io/cloud-provider-kind/cloud-controller-manager:v0.10.0"
}

# Create a container
resource "docker_container" "cloud_controller_manager" {
  image        = docker_image.cloud_controller_manager.image_id
  name         = "cloud-provider-kind"
  rm           = true
  network_mode = "host"

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
}