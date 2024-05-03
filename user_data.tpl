#! /bin/bash
apt-get update
apt-get install awscli -y
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
APPROVE_INSTALL=y ENDPOINT=$(curl http://169.254.169.254/latest/meta-data/public-ipv4) APPROVE_IP=y IPV6_SUPPORT=n PORT_CHOICE=1 PROTOCOL_CHOICE=1 DNS=1 COMPRESSION_ENABLED=n  CUSTOMIZE_ENC=n CLIENT=openvpn PASS=1 ./openvpn-install.sh
mv /root/openvpn.ovpn /tmp/
chown ubuntu: /tmp/openvpn.ovpn
chmod 777 /tmp/openvpn.ovpn
aws s3 cp /tmp/openvpn.ovpn s3://${s3_bucket}/