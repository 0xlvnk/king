#!/bin/bash

# Install badvpn-udpgw
wget -qO /usr/bin/badvpn-udpgw https://github.com/ambrop72/badvpn/releases/download/v1.999.130/badvpn-udpgw
chmod +x /usr/bin/badvpn-udpgw

# Tambahkan systemd service
cat > /etc/systemd/system/badvpn.service << EOF
[Unit]
Description=BadVPN UDPGW Service
After=network.target

[Service]
ExecStart=/usr/bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl enable badvpn.service
systemctl start badvpn.service
