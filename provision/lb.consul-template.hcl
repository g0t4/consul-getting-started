template {
  // This is the source file on disk to use as the input template. This is often
  // called the "Consul Template template". This option is required.
  source = "/vagrant/provision/haproxy.ctmpl"

  // This is the destination path on disk where the source template will render.
  // If the parent directories do not exist, Consul Template will attempt to
  // create them.
  destination = "/home/vagrant/haproxy.cfg"

  // This is the optional command to run when the template is rendered. The
  // command will only run if the resulting template changes. The command must
  // return within 30s (configurable), and it must have a successful exit code.
  // Consul Template is not a replacement for a process monitor or init system.
  command = "docker restart haproxy"
}