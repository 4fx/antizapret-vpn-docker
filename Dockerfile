FROM alpine:latest as builder
# Docker cant unpack remote archives via ADD command :(
# Lets use multistage build to download and unpack remote archive.
RUN wget https://antizapret.prostovpn.org/container-images/az-vpn/rootfs.tar.xz  \
    && mkdir /rootfs-dir  \
    && tar -xf /rootfs.tar.xz -C /rootfs-dir/

FROM scratch
COPY --from=builder /rootfs-dir /
RUN wget https://secure.nic.cz/files/knot-resolver/knot-resolver-release.deb --no-check-certificate \
    && dpkg --force-confnew -i knot-resolver-release.deb \
    && rm knot-resolver-release.deb \
    && chmod 1777 /tmp \
    && apt update -y \
    && apt upgrade -y -o Dpkg::Options::="--force-confold" \
    && wget https://ntc.party/uploads/short-url/qcZkhfK3hMdQtOGLD64orMd810D.patch -O /root/dnsmap/p.patch \
    && apt -y remove python3-dnslib \
    && apt -y install python3-pip \
    && pip3 install dnslib \
    && patch --directory /root/dnsmap -i /root/dnsmap/p.patch \
    && apt autoremove -y && apt clean -y

COPY ./init.sh /
ENTRYPOINT ["/init.sh"]
