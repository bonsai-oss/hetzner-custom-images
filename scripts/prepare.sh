#!/usr/bin/env bash

# Detect the Linux distribution
if [ -f /etc/debian_version ]; then
    DISTRO="debian"
elif [ -f /etc/redhat-release ]; then
    DISTRO="rhel"
else
    echo "Unknown distribution"
    exit 1
fi

case $DISTRO in
    debian)
        echo "Running Debian-specific command"
        apt update && apt install -y vim efibootmgr lvm2 mdadm grub-efi-amd64-bin grub-pc-bin
        ;;
    rhel)
        echo "Running RHEL-specific command"
        ;;
    *)
        # Unknown distribution
        echo "Unknown distribution"
        exit 1
        ;;
esac

