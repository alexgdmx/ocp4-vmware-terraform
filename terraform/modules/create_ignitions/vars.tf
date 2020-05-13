# __author__ = "Alejandro Guadarrama Dominguez"
# __copyright__ = "Copyright 2020, Alejandro Guadarrama Dominguez"
# __credits__ = ["Alejandro Guadarrama Dominguez"]
# __license__ = "GPL"
# __version__ = "0.0.1"
# __maintainer__ = "Alejandro Guadarrama Dominguez"
# __email__ = "alexgd.devops@gmail.com"
# __status__ = "Dev"

variable "clone_name" {
  default = ""
}

variable "folder" {
  default = ""
}

variable "resource_pool_id" {
  default = ""
}

variable "host_system_id" {
  default = ""
}

variable "datastore_id" {
  default = ""
}

variable "guest_id" {
  default = ""
}

variable "network_id" {
  default = ""
}

variable "adapter_type" {
  default = ""
}

variable "template_uuid" {
  default = ""
}

variable "ignition_config_data" {
  default = ""
}

variable "vm_data" {
  type = list
}

variable node_network {
  default = {}
}

variable cluster_name {
  default = ""
}

variable node_config {
  default = {}
}
