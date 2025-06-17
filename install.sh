#!/bin/bash
clear
echo -e "====================================="
echo -e " 🔧 VPS MENU INSTALLER by Kalvin"
echo -e "====================================="

# Update & install dependencies
apt update && apt upgrade -y
apt install -y curl wget screen cron unzip socat gnupg2 ca-certificates lsb-release \
  iptables software-properties-common dropbear stunnel4 fail2ban vnstat squid \
  openssh-server iptables-persistent netfilter-persistent

# Copy folder menu ke /root/menu
rm -rf /root/menu
cp -r menu /root/menu

# Set permission
chmod +x /root/menu/*.sh
chmod +x /root/menu/*/*.sh
chmod +x /root/menu/*/*/*.sh

# Buat agar cukup ketik `menu`
ln -sf /root/menu/menu.sh /usr/bin/menu
chmod -R +x /root/menu

# Auto generate domain acak
RANDOM_DOMAIN="vps-$(date +%s | sha256sum | head -c 6).exampledomain.com"
mkdir -p /etc/xray
echo "$RANDOM_DOMAIN" > /etc/xray/domain
echo "✅ Domain default: $RANDOM_DOMAIN"
echo "⚠️  Ganti domain kamu di menu [10] jika ingin pakai domain sendiri"

# Buat database user
mkdir -p /etc/ssh-db
touch /etc/ssh-db/users.db

# Tambah info login awal
cat > /root/menu/utils/info.sh << 'EOF'
#!/bin/bash
clear
if [[ -f /etc/ssh-db/users.db ]]; then
    ssh_count=$(wc -l < /etc/ssh-db/users.db)
else
    ssh_count=0
fi
echo -e "••••• MEMBER INFORMATION •••••"
echo -e "SSH Account     : \$ssh_count"
echo -e "Vmess Account   : 0"
echo -e "Vless Account   : 0"
echo -e "Trojan Account  : 0"
echo
echo -e "••••• SCRIPT INFORMATION •••••"
echo -e "Owner  : Kalvin"
echo -e "User   : \$(whoami)"
echo -e "ISP    : \$(curl -s ipinfo.io/org | cut -d ' ' -f2-)"
echo -e "Region : \$(curl -s ipinfo.io/city)/\$(curl -s ipinfo.io/country)"
EOF
chmod +x /root/menu/utils/info.sh

# Tambah info + menu otomatis saat login
if ! grep -q "utils/info.sh" ~/.bashrc; then
    echo "bash /root/menu/utils/info.sh" >> ~/.bashrc
fi
if ! grep -q "menu" ~/.bashrc; then
    echo "menu" >> ~/.bashrc
fi

# ===== SERVICE DASAR =====
for svc in dropbear stunnel4 cron vnstat fail2ban squid ssh sshd; do
    systemctl enable $svc 2>/dev/null
    systemctl start $svc 2>/dev/null
done

# ===== SERVICE MODULAR =====
bash /root/menu/services/xray.sh
bash /root/menu/services/dropbear-ws.sh
bash /root/menu/services/udp-custom.sh
bash /root/menu/services/badvpn.sh
bash /root/menu/services/nginx-reverse.sh
bash /root/menu/services/tls-shunt-proxy.sh


echo -e "\n✅ Install selesai! Ketik 'menu' untuk mulai."
