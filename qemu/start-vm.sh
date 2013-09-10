#!/bin/bash -ue

# IMPORTANT:
# OS in the VM has to be configured to spawn a terminal on ttyS0, eg:
#  /etc/inittab: T0:2345:respawn:/sbin/getty -L ttyS0 115200 ttyS0 vt102

# To get kernel output at boot, add the options:
#  "console=ttyS0,115200 console=tty0" 
# to the kernel cmdline of the VM.

# To direct console output from grub to the serial console add:
#  GRUB_TERMINAL=serial
#  GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0
# to the /etc/default/grub of the VM.

start_vm() {
    local brif="$1"
    local vmname="$2"
    local hdimage="$3"
    local mac="${4:-02:00:00:00:00:01}"
    local tapif="$vmname"

    sudo ip tuntap add $tapif mode tap user fholler &>/dev/null
    sudo brctl addif $brif $tapif >/dev/null
    sudo ifconfig $tapif up || exit 1
    kvm -smp 3 -m 1G \
        -netdev tap,id=net0,ifname=$tapif,script=no\
        -device virtio-net-pci,netdev=net0,mac="$mac"\
        -monitor unix:/tmp/$vmname-hmp.sock,server,nowait -nographic\
        -drive file="$hdimage",if=virtio -name "$vmname"
}

if [ $# -ne 4 ]; then
	echo "usage: $0 BRIDGE-IF VM-NAME DISK-IMAGE MAC-ADDR"
fi
start_vm "$1" "$2" "$3" "$4"
