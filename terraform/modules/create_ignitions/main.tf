# __author__ = "Alejandro Guadarrama Dominguez"
# __copyright__ = "Copyright 2020, Alejandro Guadarrama Dominguez"
# __credits__ = ["Alejandro Guadarrama Dominguez"]
# __license__ = "GPL"
# __version__ = "0.0.1"
# __maintainer__ = "Alejandro Guadarrama Dominguez"
# __email__ = "alexgd.devops@gmail.com"
# __status__ = "Dev"

data "append_bootstrap" "bootstrap" {

}

data "local_file" "master" {
  filename = "${path.module}/../deploy/master.ign"
}

data "local_file" "worker" {
  filename = "${path.module}/../deploy/worker.ign"
}

data "template_file" "ifcfg-ens192" {
  template     = file("${path.module}/templates/ifcfg-ens192.tpl")

  filesystem   = "root"
  path         = "/etc/sysconfig/network-scripts/ifcfg-ens192"
  mode         = "420"

  vars {
    ip_address = ""
    net_mask   = ""
    gateway    = ""
    domain     = ""
    dns        = ""
  }
}
