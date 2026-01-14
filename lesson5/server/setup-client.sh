#!/bin/bash
set -e

echo "=== Установка OpenVPN клиента ==="
apt update
DEBIAN_FRONTEND=noninteractive apt install -y openvpn

# Ждём, пока сервер создаст конфиги (в реальном сценарии — лучше через provision order)
sleep 10

# Копируем клиентские файлы (они попадут из shared folder Vagrant)
mkdir -p /etc/openvpn/client
cp /vagrant/client-config/* /etc/openvpn/client/

# Конфиг клиента
cat > /etc/openvpn/client.conf <<EOF
client
dev tun
proto udp
remote 192.168.56.10 1194
resolv-retry infinite
nobind
user nobody
group nogroup
persist-key
persist-tun
ca /etc/openvpn/client/ca.crt
cert /etc/openvpn/client/client1.crt
key /etc/openvpn/client/client1.key
tls-auth /etc/openvpn/client/ta.key 1
cipher AES-256-CBC
auth SHA256
comp-lzo
verb 3
redirect-gateway def1
EOF

# Отключаем обычный шлюз → интернет только через VPN
# Сохраняем оригинальный маршрут на случай отладки
ORIGINAL_GW=$(ip route show default | awk '{print $3}')
echo "Оригинальный шлюз: $ORIGINAL_GW"

# Удаляем маршрут по умолчанию
ip route del default

# Запускаем OpenVPN
systemctl enable --now openvpn@client

echo "Клиент настроен. Интернет должен работать ТОЛЬКО через OpenVPN."