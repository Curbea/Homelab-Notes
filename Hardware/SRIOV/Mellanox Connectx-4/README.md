Was all the pain getting this to work worth it? No, but I paid for a whole card, I'm going to use the whole card :)

Bio:
Getting SR-IOV on my NIC working with my setup and requirements was a very trying experience. Any issues usually resulted in the loss of access to OPNsense's web page, sometimes Proxmox was unable to communicate with its own backup server, and depending on what I was experimenting with, the whole bridge went down, necessitating physical access. This made trials very time-consuming to recover from. I started experimenting with this with very little information regarding networks, so finding solutions to problems I did not know the names of was challenging. 

One of my first attempts a windows vm was able to get a dhcp reservation from the opnsense vm but both systems were unable to ping eachother.

I switched from Linux bridge to OVS bridge to get SR-IOV working on both physical functions. 

Below are the two main approaches used in this setup I tried to get this working. 

## Approaches:

## Adding to Linux Bridge FDB
This approach involves modifying the bridge forwarding database (FDB) to include the MAC addresses of bridged containers (CT) and virtual machines (VM) on the upstream Physical Function (PF) interface. Script source 

[jdlayman pve-hookscript](https://github.com/jdlayman/pve-hookscript-sriov)
## Issue:
This works, there would not be any issues and I likely would have kept this solution, but I have two physical interfaces, so sriov traffic would not 'cross the bridge' for the phyical interfaces. This would leave me needing to passthrough 2 vf and create bridges in each vm which doesn't make sense to do. Oddly adding the bridge itself with the vf to the vm did enable this passthrough

We do not get any hardware offloading with this, probably un needed, but again see first line :)
Key Points:

The hook script adds or removes MAC addresses to/from the bridge FDB during various phases (pre-start, post-stop) of the VM lifecycle.
Ensures proper network communication between the SR-IOV Virtual Functions (VF) and the bridge.
The script dynamically adjusts based on the VM configuration and the network setup.
[Proxmox Forums - More discussion on this](https://forum.proxmox.com/threads/communication-issue-between-sriov-vm-vf-and-ct-on-pf-bridge.68638/)
## Switching to OVS and Using VF Representors
This approach leverages Open vSwitch (OVS) and representor ports to handle SR-IOV VFs.

Key Points:

Transition from Linux bridge to OVS bridge for better SR-IOV support.
Configuration includes setting up SR-IOV VFs, unbinding the default driver, enabling eSwitch, and configuring OVS with the representor ports.
The script sets up the OVS bridge, adds the physical network ports, and brings up the necessary interfaces.
A more stable and flexible solution that integrates well with modern network setups.

## Roadblocks and issues I've encountered

Roadblock 1: Driver Unbinding and Binding
Unbinding the mlx5_core driver from the VFs while keeping it bound on the PF while also getting vfio-pci to bind to the VFs was challenging. Using driverctl resolved this issue, though there is a goal to move away from this dependency as more knowledge is gained. I had a udev rule which accomplished this; but it was very much an all or nothing

Roadblock 2: PF, SR-IOV, and Linux Bridges
Diagnosing and fixing issues related to PF, SR-IOV, and Linux bridges was the biggest hurdle. Switching to OVS bridges with representor ports proved to be a more reliable solution.

Conclusion
Switching to OVS bridges and using representor ports significantly improved the stability and functionality of the SR-IOV setup. The detailed scripts and configurations provided allow for replicating the setup and addressing common issues encountered during the process.
