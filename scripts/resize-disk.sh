#!/bin/bash

set -e

echo "========================================="
echo " Disk Resize Started"
echo "========================================="

# Check root
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Please run with sudo."
    exit 1
fi

echo ""
echo "Before Resize:"
lsblk

echo ""
echo "Extending partition 4..."

growpart /dev/nvme0n1 4

echo ""
echo "Resizing Physical Volume..."

pvresize /dev/nvme0n1p4

echo ""
echo "Extending root volume by 20G..."

lvextend -L +20G /dev/RootVG/rootVol

echo ""
echo "Extending /var by 10G..."

lvextend -L +10G /dev/RootVG/varVol

echo ""
echo "Giving remaining free space to /var/tmp..."

lvextend -l +100%FREE /dev/RootVG/varTmpVol

echo ""
echo "Growing XFS filesystems..."

xfs_growfs /

xfs_growfs /var

xfs_growfs /var/tmp

echo ""
echo "========================================="
echo " Disk Resize Completed Successfully"
echo "========================================="

echo ""
echo "After Resize:"
lsblk

echo ""
echo "Filesystem Usage:"
df -h