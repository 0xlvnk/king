#!/bin/bash
clear
echo -e "\033[1;36m======= DAFTAR AKUN SSH =======\033[0m"
printf "%-15s %-15s\n" "Username" "Expired Date"
echo "-------------------------------"

count=0

if [[ -f /etc/ssh-db/users.db ]]; then
    while IFS='|' read -r user pass exp owner limit; do
        printf "%-15s %-15s\n" "$user" "$exp"
        ((count++))
    done < /etc/ssh-db/users.db

    echo "-------------------------------"
    echo -e "Total Akun SSH: $count"
else
    echo "Belum ada akun yang dibuat."
fi
