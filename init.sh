#!/usr/bin/env bash

if [[ ! -f /root/easy-rsa-ipsec/easyrsa3/easyrsa ]]
# We need to  easyrsa3/pki folder to be persistent.
# But we cant just symlink it, because easyrsa will try to remove it and crash during key regeneration.
# So we replace existing folder with link from host.
then
    curl -L https://github.com/OpenVPN/easy-rsa/releases/download/v3.1.0/EasyRSA-3.1.0.tgz | tar -xz
    mv EasyRSA-3.1.0/* /root/easy-rsa-ipsec/easyrsa3
    rm -rf EasyRSA-3.1.0/
fi

echo "nameserver 1.1.1.1" >> /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf
echo "nameserver 9.9.9.9" >> /etc/resolv.conf
echo "nameserver 149.112.112.112" >> /etc/resolv.conf

/root/easy-rsa-ipsec/generate.sh \
&& exec /usr/sbin/init