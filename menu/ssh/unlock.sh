#!/bin/bash
read -rp "Username yang ingin dibuka: " user
if id "$user" &>/dev/null; then
    usermod -U "$user"
    echo "✅ User '$user' berhasil dibuka."
else
    echo "❌ User '$user' tidak ditemukan!"
fi
read -n 1 -s -r -p "Tekan tombol apapun untuk kembali..."
