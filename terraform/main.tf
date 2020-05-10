# __author__ = "Alejandro Guadarrama Dominguez"
# __copyright__ = "Copyright 2020, Alejandro Guadarrama Dominguez"
# __credits__ = ["Alejandro Guadarrama Dominguez"]
# __license__ = "GPL"
# __version__ = "0.0.1"
# __maintainer__ = "Alejandro Guadarrama Dominguez"
# __email__ = "alexgd.devops@gmail.com"
# __status__ = "Dev"

#  Deploy ocp4 infrastructure to vmware

variable vsphere_user {}
variable vsphere_password {}
variable vsphere_server {}
variable ocp_cluster_name {}
variable full_path {}
variable virtual_machines {}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "BHM"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "sni" {
  name          = "sni"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "cluster" {
  path          = var.ocp_cluster_name
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "sni" {
  name          = "sni/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "esxi67" {
  name          = "esxi67.sni.com.mx"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "rhcos_template" {
  name          = "rhcos-4.4.3-x86_64-vmware.x86_64.ova"
  datacenter_id = data.vsphere_datacenter.dc.id
}

module "bootstrap" {
  source           = "./modules/clone_from_template"
  folder           = vsphere_folder.cluster.path
  resource_pool_id = data.vsphere_resource_pool.sni.id
  host_system_id   = data.vsphere_host.esxi67.id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id         = data.vsphere_virtual_machine.rhcos_template.guest_id
  network_id       = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.rhcos_template.network_interface_types[0]
  template_uuid    = data.vsphere_virtual_machine.rhcos_template.id
  vm_data          = var.virtual_machines.bootstrap
}

module "master" {
  source           = "./modules/clone_from_template"
  folder           = vsphere_folder.cluster.path
  resource_pool_id = data.vsphere_resource_pool.sni.id
  host_system_id   = data.vsphere_host.esxi67.id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id         = data.vsphere_virtual_machine.rhcos_template.guest_id
  network_id       = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.rhcos_template.network_interface_types[0]
  template_uuid    = data.vsphere_virtual_machine.rhcos_template.id
  vm_data          = var.virtual_machines.master
}

module "worker" {
  source           = "./modules/clone_from_template"
  folder           = vsphere_folder.cluster.path
  resource_pool_id = data.vsphere_resource_pool.sni.id
  host_system_id   = data.vsphere_host.esxi67.id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id         = data.vsphere_virtual_machine.rhcos_template.guest_id
  network_id       = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.rhcos_template.network_interface_types[0]
  template_uuid    = data.vsphere_virtual_machine.rhcos_template.id
  vm_data          = var.virtual_machines.worker
}

module "infra" {
  source           = "./modules/clone_from_template"
  folder           = vsphere_folder.cluster.path
  resource_pool_id = data.vsphere_resource_pool.sni.id
  host_system_id   = data.vsphere_host.esxi67.id
  datastore_id     = data.vsphere_datastore.datastore.id
  guest_id         = data.vsphere_virtual_machine.rhcos_template.guest_id
  network_id       = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.rhcos_template.network_interface_types[0]
  template_uuid    = data.vsphere_virtual_machine.rhcos_template.id
  vm_data          = var.virtual_machines.infra
}
