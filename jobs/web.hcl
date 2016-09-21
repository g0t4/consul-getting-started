job "web" {
  region = "us"

  datacenters = [
    "nyc"
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
    count = 3

    task "web" {
      # docker driver docs: https://www.nomadproject.io/docs/drivers/docker.html
      driver = "docker"

      config {
        image = "nginx:1.10-alpine"

        # nginx:1.10-alpine listens on a fixed port of 80
        # so we need to map container port 80 to the dynamic http port on the host
        # more about networking here: https://www.nomadproject.io/docs/jobspec/networking.html
        port_map {
          http = "80"
        }
      }


      # for service definition, see https://www.nomadproject.io/docs/jobspec/servicediscovery.html
      service {
        name = "web"
        # map the http port (see resource block) to this service definition
        # whatever port is defined below will be passed along to consul
        # in this case, because of the resource block below, the port is dynamic, so the assigned port will be passed along for service discovery via consul
        # this really shows the power of Nomad + Consul hand in hand
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
          # to understand port allocation: https://www.nomadproject.io/docs/jobspec/index.html#resources
          # Request that nomad provide a dynamic port, called http
          # Nomad will assign a dynamic port resource
          # So this is a port allocated on the host, bound to the network_interface detected during fingerprinting or configured
          port "http" {
            # if you want a static port, then add the following:
            # static = 8080
          }
        }
      }
    }
  }
}
