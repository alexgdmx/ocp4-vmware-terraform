
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

output template {
  value = vsphere_virtual_machine_snapshot.template.id
}
