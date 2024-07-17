Getting Sriov on my nic working with my setup and requirments was a very trying expieriance; any issues usually resulted in loss of access to Opnsense's web page, sometimes proxmox was unable to communicate with it's own backup server, and depending on what I was experimenting with, the whole bridge went down; necessitating physical access. This made trials very time consuming.

There is some information online troubleshooting for this purpose.

I'm not going to write about enabling sriov as that process was straightforward;

 ## Roadblock 1:
 
 Unbinding mlnx driver from vf while keeping it bound on the pf and binding vfio-pci to the vf's. For whatever reason whenvever I was able to get the mlnx driver off the vf's the vfio-pci driver was unable to bind. Adding to the /etc/modules, adding a udev rule did not accomplish this. Driverctl was able to remedy this but I'm hoping I will be able to eventually move away from this dependancy as I learn more.

 ## Roadblock 2:

PF, Sriov and Linux bridges;

Biggest hurdle in diagnosing and fixing


https://netdevconf.info/1.2/slides/oct6/04_gerlitz_efraim_introduction_to_switchdev_sriov_offloads.pdf

https://forums.servethehome.com/index.php?threads/fully-utilizing-the-connectx-5-eswitch-switchdev-functionality-in-proxmox-ve.44740/
https://forum.proxmox.com/threads/communication-issue-between-sriov-vm-vf-and-ct-on-pf-bridge.68638/
