#!/bin/bash

# Primary device name and location.
DEVNAME=enp2s0f0
DevName2=enp2s0f1
DEVPCIBASE=0000:02:0

# Add SR-IOV virtual functions.
/usr/bin/echo 8 > /sys/class/net/${DEVNAME}/device/sriov_numvfs
/usr/bin/echo 8 > /sys/class/net/${DEVNAME2}/device/sriov_numvfs


# Set MAC addresses for the pf virtual functions.
/usr/bin/ip link set ${DEVNAME} vf 0 mac 76:9e:17:83:39:e5
/usr/bin/ip link set ${DEVNAME} vf 1 mac 46:2c:6d:24:6b:1b
/usr/bin/ip link set ${DEVNAME} vf 2 mac 3e:47:48:12:ed:94
/usr/bin/ip link set ${DEVNAME} vf 3 mac be:e3:6a:f3:8f:ac
/usr/bin/ip link set ${DEVNAME} vf 4 mac 62:8f:3d:bb:02:08
/usr/bin/ip link set ${DEVNAME} vf 5 mac ae:91:57:b9:14:7f
/usr/bin/ip link set ${DEVNAME} vf 6 mac 5a:c2:08:a9:68:a7
/usr/bin/ip link set ${DEVNAME} vf 7 mac b2:f0:18:af:cb:c5
# Set MAC addresses for the 2nd pf virtual functions.
/usr/bin/ip link set ${DEVNAME2} vf 0 mac 16:47:7c:a8:95:98
/usr/bin/ip link set ${DEVNAME2} vf 1 mac a6:c7:c5:7f:9c:22
/usr/bin/ip link set ${DEVNAME2} vf 2 mac b6:0f:45:34:5e:19
/usr/bin/ip link set ${DEVNAME2} vf 3 mac 2a:f7:37:84:31:30
/usr/bin/ip link set ${DEVNAME2} vf 4 mac 8a:fa:f8:c5:0b:93
/usr/bin/ip link set ${DEVNAME2} vf 5 mac b2:f5:d5:2f:79:06
/usr/bin/ip link set ${DEVNAME2} vf 6 mac c2:92:f5:fa:32:20
/usr/bin/ip link set ${DEVNAME2} vf 7 mac 2e:fb:29:1e:48:31
# Unbind the virtual functions.
/usr/bin/echo ${DEVPCIBASE}0.2 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.3 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.4 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.5 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.6 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.7 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.0 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.1 > /sys/bus/pci/drivers/mlx5_core/unbind
#2nd PF
/usr/bin/echo ${DEVPCIBASE}0.2 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.3 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.4 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.5 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.6 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.7 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.0 > /sys/bus/pci/drivers/mlx5_core/unbind
/usr/bin/echo ${DEVPCIBASE}0.1 > /sys/bus/pci/drivers/mlx5_core/unbind
# Enable the eSwitch.
/usr/sbin/devlink dev eswitch set pci/${DEVPCIBASE}0.0 mode switchdev
/usr/sbin/devlink dev eswitch set pci/${DEVPCIBASE}0.1 mode switchdev

# Set up OpenVSwitch.
/usr/bin/ovs-vsctl add-br vmbr5
/usr/bin/ovs-vsctl set Open_vSwitch . other_config:hw-offload=true

systemctl restart openvswitch-switch.service

# Add the first network port as well as the representer devices.
/usr/bin/ovs-vsctl add-port vmbr5 ${DEVNAME}
for i in `ls /sys/class/net/${DEVNAME}/device/net/ | grep -v ${DEVNAME}`; do
  /usr/bin/ovs-vsctl add-port vmbr2 ${i};
done;

/usr/bin/ovs-vsctl add-port vmbr5 ${DEVNAME2}
for i in `ls /sys/class/net/${DEVNAME2}/device/net/ | grep -v ${DEVNAME2}`; do
  /usr/bin/ovs-vsctl add-port vmbr2 ${i};
done;


# Bring up the switch, the physical port, and the representer devices.
/usr/bin/ip link set dev vmbr5 up
/usr/bin/ip link set dev ${DEVNAME} up
/usr/bin/ip link set dev ${DEVNAME2} up
for i in `ls /sys/class/net/${DEVNAME}/device/net/ | grep -v ${DEVNAME}`; do
  /usr/bin/ip link set dev ${i} up
done;

for i in `ls /sys/class/net/${DEVNAME2}/device/net/ | grep -v ${DEVNAME2}`; do
  /usr/bin/ip link set dev ${i} up
done;

# Bind first VF to host
/usr/bin/driverctl set-override ${DEVPCIBASE}0.2 mlx5_core
#Bind the rest of the VF's to vfio
#Pf 1
/usr/bin/driverctl set-override ${DEVPCIBASE}0.3 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}0.4 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}0.5 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}0.6 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}0.7 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}1.0 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}1.1 vfio_pci
#Pf 2
/usr/bin/driverctl set-override ${DEVPCIBASE}1.2 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}1.3 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}1.4 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}1.5 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}1.6 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}1.7 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}2.0 vfio_pci
/usr/bin/driverctl set-override ${DEVPCIBASE}2.1 vfio_pci
