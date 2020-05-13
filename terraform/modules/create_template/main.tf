# __author__ = "Alejandro Guadarrama Dominguez"
# __copyright__ = "Copyright 2020, Alejandro Guadarrama Dominguez"
# __credits__ = ["Alejandro Guadarrama Dominguez"]
# __license__ = "GPL"
# __version__ = "0.0.1"
# __maintainer__ = "Alejandro Guadarrama Dominguez"
# __email__ = "alexgd.devops@gmail.com"
# __status__ = "Dev"

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "esxi67" {
  name          = var.host
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "template" {
  name                        = var.name
  datacenter_id               = data.vsphere_datacenter.dc.id
  resource_pool_id            = var.resource_pool_id
  datastore_id                = data.vsphere_datastore.datastore.id
  host_system_id              = data.vsphere_host.esxi67.id
  folder                      = var.folder
  enable_disk_uuid            = true
  wait_for_guest_net_timeout  = 0
  wait_for_guest_net_routable = false
  boot_delay                  = 10000

  ovf_deploy {
    local_ovf_path = var.local_ovf
    disk_provisioning  = "thin"
  }
}


output template_id {
  value = vsphere_virtual_machine.template.id
}

output guest_id {
  value = vsphere_virtual_machine.template.guest_id
}

output adapter_type {
  value = vsphere_virtual_machine.template.network_interface
}

output machine {
  value = vsphere_virtual_machine.template.id
}
