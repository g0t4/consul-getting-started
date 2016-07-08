job "web" {
  region = "nyc"

  datacenters = [
    "nyc-1"
  ]

  type = "service"

  # Rolling updates should be sequential
  update {
    stagger = "30s"
    max_parallel = 1
  }

  # A group is colocated on one node
  group "webs" {

    # We want 5 web servers
    count = 5

    task "web" {
      driver = "docker"
      config {
        image = "nginx"
      }
      service {
        name = "web"
        port = "http"
        check {
          type = "http"
          path = "/"
          interval = "10s"
          timeout = "2s"
        }
      }
      resources {
        network {
          mbits = 1
          # Request for a dynamic port
          port "http" {
          }
        }
      }
    }
  }
}
