#!/bin/bash
# Qemu script for installing booting an install .iso with a bare disk
set -e

ISO_LOCATION="$1"
DISK="$2"

if [[ ! -f "$ISO_LOCATION" ]]; then
	echo "Invalid ISO location (first argument): $ISO_LOCATION" >&2
	exit 1
fi
if [[ ! -b "$DISK" ]]; then
	echo "Invalid block device (second argument): $DISK" >&2
	exit 1
fi
# check if the drive is USB-based
transport=$(lsblk "$DISK" -nl -o tran | head -1)
if [[ "$transport" != "usb" ]]; then
	echo "Disk transport not allowed: $transport" >&2
	exit 1
fi

QEMUARGS=(-enable-kvm -boot d -m 512 -L . --bios /usr/share/ovmf/x64/OVMF_CODE.fd)
sudo qemu-system-x86_64 -drive "format=raw,file=$DISK" \
	-drive "format=raw,media=cdrom,readonly,file=$ISO_LOCATION" \
	"${QEMUARGS[@]}"

