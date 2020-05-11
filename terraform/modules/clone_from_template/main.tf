# __author__ = "Alejandro Guadarrama Dominguez"
# __copyright__ = "Copyright 2020, Alejandro Guadarrama Dominguez"
# __credits__ = ["Alejandro Guadarrama Dominguez"]
# __license__ = "GPL"
# __version__ = "0.0.1"
# __maintainer__ = "Alejandro Guadarrama Dominguez"
# __email__ = "alexgd.devops@gmail.com"
# __status__ = "Dev"

resource "vsphere_virtual_machine" "clone" {
  count            = length(var.vm_data)
  name             = tomap(var.vm_data[count.index]).name
  folder           = var.folder
  resource_pool_id = var.resource_pool_id
  host_system_id   = var.host_system_id
  datastore_id     = var.datastore_id
  enable_disk_uuid = true
  wait_for_guest_net_timeout = -1
  wait_for_guest_net_routable = false

  num_cpus = 4
  memory   = 16384
  guest_id = var.guest_id

  network_interface {
    network_id   = var.network_id
    adapter_type = var.adapter_type
  }

  disk {
    # eagerly_scrub    = false
    thin_provisioned = false
    label            = "disk00"
    size             = 120
  }

  clone {
    template_uuid = var.template_uuid
    linked_clone  = false
  }

  vapp {
    properties = {
      "guestinfo.ignition.config.data"          = tomap(var.vm_data[count.index]).data64
      "guestinfo.ignition.config.data.encoding" = "base64"
    }
  }
}

output vm_data {
  value = var.vm_data
}
