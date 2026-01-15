#!/bin/bash
set -e

echo "=== Установка OpenVPN и Easy-RSA ==="
apt update
DEBIAN_FRONTEND=noninteractive apt install -y openvpn easy-rsa iptables-persistent

# Настройка PKI
make-cadir /root/openvpn-ca
cd /root/openvpn-ca

# Заполнение vars
cat > vars <<EOF
export KEY_COUNTRY="RU"
export KEY_PROVINCE="MSK"
export KEY_CITY="Moscow"
export KEY_ORG="DemoOrg"
export KEY_EMAIL="admin@example.com"
export KEY_OU="IT"
export KEY_NAME="server"
export KEY_CN="server"
EOF

source ./vars
./clean-all
./build-ca --batch
./build-key-server --batch server
./build-dh
openvpn --genkey --secret keys/ta.key

# Генерация клиента
./build-key --batch client1

# Конфиг сервера
cat > /etc/openvpn/server.conf <<EOF
port 1194
proto udp
dev tun
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh2048.pem
tls-auth /etc/openvpn/ta.key 0
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
keepalive 10 120
cipher AES-256-CBC
auth SHA256
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
explicit-exit-notify 1
EOF

# Копирование ключей
cp /root/openvpn-ca/keys/{ca.crt,server.crt,server.key,dh2048.pem,ta.key} /etc/openvpn/

# IP forwarding
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p

# NAT
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables/rules.v4

# Запуск
systemctl enable --now openvpn@server

# Копируем клиентские файлы для передачи (в реальности — scp или shared folder)
mkdir -p /vagrant/client-config
cp /root/openvpn-ca/keys/{ca.crt,client1.crt,client1.key,ta.key} /vagrant/client-config/
echo "OpenVPN server готов. Клиентские файлы в /vagrant/client-config/"