# __author__ = "Alejandro Guadarrama Dominguez"
# __copyright__ = "Copyright 2020, Alejandro Guadarrama Dominguez"
# __credits__ = ["Alejandro Guadarrama Dominguez"]
# __license__ = "GPL"
# __version__ = "0.0.1"
# __maintainer__ = "Alejandro Guadarrama Dominguez"
# __email__ = "alexgd.devops@gmail.com"
# __status__ = "Dev"


data "ignition_file" "hostname" {
  count = length(var.node_config.hostname)

  filesystem = "root"
  path       = "/etc/hostname"
  mode       = "420"

  content {
    content = "${element(var.node_config.hostname, count.index)}.${var.cluster_name}.${var.node_network.ocp_domain}"
  }
}

data "template_file" "ifcfg-ens192" {
  count        = length(var.node_config.ip)
  template     = file("${path.module}/templates/ifcfg-ens192.tpl")

  vars = {
    ip_address = element(var.node_config.ip, count.index)
    net_mask   = var.node_network.prefix
    gateway    = var.node_network.gateway
    domain     = "${var.cluster_name}.${var.node_network.ocp_domain}"
    dns        = var.node_network.dns
  }
}

data "ignition_file" "static_ip" {
  count = length(var.node_config.ip)

  filesystem = "root"
  path       = "/etc/sysconfig/network-scripts/ifcfg-ens192"
  mode       = "420"

  source {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(data.template_file.ifcfg-ens192[count.index].rendered)}"
  }
}

data "ignition_systemd_unit" "restart" {
  name = "restart.service"
  content = file("${path.module}/templates/systemd_restart")
}


data "ignition_config" "ign" {
  count = length(var.node_config.ip)

  append {
    source = "${var.url_ignition}/${var.type}.ign"
  }

  systemd = [
    data.ignition_systemd_unit.restart.rendered
  ]

  files = [
    data.ignition_file.hostname[count.index].rendered,
    data.ignition_file.static_ip[count.index].rendered
  ]
}


output data {
  value = data.ignition_config.ign.*.rendered
}
