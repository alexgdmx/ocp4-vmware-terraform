# __author__ = "Alejandro Guadarrama Dominguez"
# __copyright__ = "Copyright 2020, Alejandro Guadarrama Dominguez"
# __credits__ = ["Alejandro Guadarrama Dominguez"]
# __license__ = "GPL"
# __version__ = "0.0.1"
# __maintainer__ = "Alejandro Guadarrama Dominguez"
# __email__ = "alexgd.devops@gmail.com"
# __status__ = "Dev"

variable node_network {
  default = {}
}

variable cluster_name {
  default = ""
}

variable node_config {
  default = {}
}

variable root_path {
  default = ""
}

variable type {
  default = "bootstrap"
}

variable url_ignition {
  default = ""
}
