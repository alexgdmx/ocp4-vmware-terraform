# ocp4-vmware-terraform
# Update 05/13/2020 100% terraform

The following procedure is intended to create VM's from an **OVA** template booting with **static IP's** when the DHCP server **can not** reserve the IP addresses.

#### The problem
OCP requires that all DNS configurations be in place. VMWare requires that the DHCP assign the correct IPs to the VM. Since many real installations require the coordination with different teams in an organization, many times we don't have control of DNS, DHCP or Loadbalancer configurations.

Sometimes we need to do a **["bare metal"](https://docs.openshift.com/container-platform/4.3/installing/installing_bare_metal/installing-bare-metal.html)** installation over vmware to set the network configuration with kernel parameters at boot (ip, gateway, nameserver, etc.).

The coreos [documentation](https://coreos.com/ignition/docs/latest/network-configuration.html) explain how to create configurations using ignition files. I created a python script to put the network configuration using the ignition files created by the openshift-install program.

#### How does it work?
When the VM boots, it will take the first IP provided by the DHCP server (probably will not be the IP set by the script). ``(...dhclient[836]: bound to 10.56.240.99 -- renewal in 18253 seconds.)``

![Temporary IP](images/temp_ip.jpg "Temporary IP")

At the end of the boot process the VM will take the IP provided by the ignition file.

![Final IP](images/final_ip.jpg "Final IP")

# Start:
## Pre-requirements
- Terraform latest version (v0.12.24) you can download [here](https://www.terraform.io/downloads.html)
- Have the ignitions files already created (bootstrap.ign, master.ign, worker.ign).
- Copy the 3 ignitions files to your webserver.
- Download the OVA image from the [mirror repository](https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/latest/latest/rhcos-4.4.3-x86_64-vmware.x86_64.ova) to the ``terraform/`` folder.
- **Optional** ``install-config.yaml`` file.
- **Optional:** The fist section of **script** ``go.sh`` create the ignition files and copy to the webserver, if you already did this process you can delete that part and start from the **Terraforn deployment** section.


## Procedure
1. Edit the file ``terraform/vars/common.tfvars`` with the values of your installation; vmware configuration and Openshift configuration.

2. Extract the contents from the OVA file, wi will get 2 files: ``coreos.ovf`` and ``disk.vmdk``.
```bash
../terraform$ tar xvf rhcos-4.4.3-x86_64-vmware.x86_64.ova
coreos.ovf
disk.vmdk
```
3. I made an script ``go.sh`` with all steps

#### Destroy
You can easily destroy the bootstrap once you don't need it anymore.
```bash
alex@:/../terraform $ ./destroy --target=module.bootstrap
data.vsphere_datacenter.dc: Refreshing state...
data.vsphere_host.esxi67: Refreshing state...
Plan: 0 to add, 0 to change, 1 to destroy.
.
Warning: Resource targeting is in effect
.
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.
.
  Enter a value: yes
.  
module.bootstrap.vsphere_virtual_machine.clone[0]: Destroying... [id=423147d7-b7ff-11d2-1762-a2e10dd37584]
module.bootstrap.vsphere_virtual_machine.clone[0]: Destruction complete after 9s
.
Destroy complete! Resources: 1 destroyed.
```
Or you can destroy everything
```bash
alex@:/../terraform $ ./destroy
Plan: 0 to add, 0 to change, 4 to destroy.
.
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.
.
  Enter a value: yes
  module.master.vsphere_virtual_machine.clone[1]: Destroying... [id=4231f92a-08c9-6afe-7f0c-b17105e7991a]
  module.master.vsphere_virtual_machine.clone[0]: Destroying... [id=4231da99-3018-40dd-2532-157990aea86f]
  module.master.vsphere_virtual_machine.clone[2]: Destroying... [id=423188fc-571c-f243-367c-c6edaf8906b2]
  module.master.vsphere_virtual_machine.clone[2]: Destruction complete after 4s
  module.master.vsphere_virtual_machine.clone[1]: Destruction complete after 4s
  module.master.vsphere_virtual_machine.clone[0]: Destruction complete after 5s
  vsphere_folder.cluster: Destroying... [id=group-v185]
  vsphere_folder.cluster: Destruction complete after 0s
.  
  Destroy complete! Resources: 4 destroyed.
```

References
- https://docs.openshift.com/container-platform/4.3/installing/installing_vsphere/installing-vsphere.html
- https://docs.openshift.com/container-platform/4.3/installing/installing_bare_metal/installing-bare-metal.html
- https://github.com/pyenv/pyenv
- https://www.terraform.io/
- https://github.com/terraform-providers/terraform-provider-vsphere
- https://github.com/vmware/govmomi/tree/master/govc
- https://coreos.com/ignition/docs/latest/network-configuration.html
- https://coreos.com/ignition/docs/latest/examples.html
