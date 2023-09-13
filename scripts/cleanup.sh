rm -f /etc/ssh/ssh_host_*
rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -f /etc/sysconfig/network-scripts/ifcfg-en*
rm -f /etc/NetworkManager/system-connections/*.nmconnection

# remove efi nvram vars
rm -f /boot/efi/NvVars

# remove ansible dir
rm -rf /root/.ansible

# remove kickstart files
rm -f /root/anaconda-ks.cfg
rm -f /root/original-ks.cfg

truncate -s0 /etc/resolv.conf

rm -f /var/lib/dhclient/dhclient-*.lease
rm -rf /tmp/*

find /var/log -type f \( -regex '.*\.[0-9]+$' -or -regex '.*\.gz$' -or -regex '.*\.old$' -or -regex '.*\.xz$' \) -delete
find /var/log -type d -empty -not -name journal -not -name private -not -name chrony -delete
find /var/log -type f -not -empty -exec truncate -s0 {} \;

truncate -s0 /etc/machine-id
truncate -s0 /var/lib/NetworkManager/secret_key

rm -f /var/lib/systemd/random-seed
