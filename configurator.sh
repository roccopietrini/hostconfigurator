#!/bin/sh

if ! type jq > /dev/null; then
  sudo apt-get intall jq
fi

NIC=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2a;getline}')

ID=$(cat ../config.json | jq '.field1.id | tonumber')

IDs=$(cat ../config.json | jq '.field2.id | tonumber')

cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto $NIC
iface $NIC inet static
	address 192.168.0.$(($ID-$IDs+10))
	netmask 255.255.255.0
	gateway 192.168.0.1
	dns-nameservers 192.168.0.1
EOF

cat << EOF > /etc/hostname
camera$ID
EOF

cat << EOF > /etc/hosts
127.0.0.1	localhost
127.0.1.1	field$ID

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

reboot
