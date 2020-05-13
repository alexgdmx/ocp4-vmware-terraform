# __author__ = "Alejandro Guadarrama Dominguez"
# __copyright__ = "Copyright 2020, Alejandro Guadarrama Dominguez"
# __credits__ = ["Alejandro Guadarrama Dominguez"]
# __license__ = "GPL"
# __version__ = "0.0.1"
# __maintainer__ = "Alejandro Guadarrama Dominguez"
# __email__ = "alexgd.devops@gmail.com"
# __status__ = "Dev"

vsphere_user     = "administrator@sni.com.mx"
vsphere_password = "Password123!"
vsphere_server   = "vcenter.sni.com.mx"

datacenter = "BHM"
datastore = "datastore1"
cluster = "sni"
network = "VM Network"
resource_pool = "sni/Resources"
host = "esxi67.sni.com.mx"

template = {
    name     = "rhcos-4.4.3-template"
    ovf_name = "coreos.ovf"
}

node_network = {
  netmask    = "255.255.254.0"
  nm_num     = 23
  gateway    = "10.56.240.254"
  dns        = "10.56.240.1"
  ocp_domain = "sni.com.mx"
}

ocp_cluster_name = "ocp4"

node_configs = {
  bootstrap = {
    ip       = ["10.56.241.12"]
    hostname = ["bootstrap"]
    cpu      = 4
    memory   = 16384
    disk     = 120
  }
  master = {
    ip       = ["10.56.241.13", "10.56.241.14", "10.56.241,15"]
    hostname = ["master01", "master02", "master03"]
    cpu      = 4
    memory   = 16384
    disk     = 120
  }
  worker = {
    ip       = ["10.56.241.16", "10.56.241.17"]
    hostname = ["worker01", "worker02"]
    cpu      = 4
    memory   = 16384
    disk     = 120
  }
  infra = {
    ip       = ["10.56.241.18", "10.56.241.19"]
    hostname = ["infra01", "infra02"]
    cpu      = 2
    memory   = 8192
    disk     = 120
  }
  logging = {
    ip       = ["10.56.241.20", "10.56.241.21"]
    hostname = ["logging01", "logging02"]
    cpu      = 2
    memory   = 8192
    disk     = 120
  }
}
