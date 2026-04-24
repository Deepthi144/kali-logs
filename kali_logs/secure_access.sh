#!/bin/bash

# 🔐 Telegram Configuration
BOT_TOKEN="7804044220:AAFpjKipRk3_B1Wsago-K3LDV2iycxaLZqk"
CHAT_ID="7361230402"

# 👤 Login Credentials
USERNAME="admin"
PASSWORD="this@kalilinux"

# 📂 Confidential File
FILE_PATH="$HOME/project_logs/college_records.xlsx"

# 🖥 System Info
SYSTEM_NAME=$(hostname)
IP_ADDRESS=$(hostname -I | awk '{print $1}')
CURRENT_USER=$(whoami)

count=0

clear
echo "=================================================="
echo "        🛡 CONFIDENTIAL ACCESS PORTAL 🛡"
echo "=================================================="
echo ""

while [ $count -lt 3 ]; do

    echo "------------------------------------------"
    read -p "👤 Username: " input_user
    read -sp "🔑 Password: " input_pass
    echo ""
    echo "------------------------------------------"

    if [[ "$input_user" == "$USERNAME" && "$input_pass" == "$PASSWORD" ]]; then
        echo ""
        echo "✅ Authentication Successful!"
        echo "📂 Opening Confidential Records..."
        sleep 2

        xdg-open "$FILE_PATH" >/dev/null 2>&1 &
        exit 0

    else
        count=$((count+1))
        echo "❌ Invalid Credentials. Try again."
        
        # Telegram Warning on 2nd Attempt
        if [ $count -eq 2 ]; then
            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
            -d chat_id="$CHAT_ID" \
            -d text="⚠️ WARNING!

Unauthorized login attempt detected.

👤 User: $CURRENT_USER
🖥 System: $SYSTEM_NAME
🌐 IP: $IP_ADDRESS
🕒 Time: $(date)
Attempt: 2" \
            >/dev/null 2>&1
        fi

        # Block on 3rd Attempt
        if [ $count -eq 3 ]; then
            echo "🚫 System Locked due to Multiple Failed Attempts."

            curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
            -d chat_id="$CHAT_ID" \
            -d text="🚨 FRAUD ALERT 🚨

Multiple failed login attempts.

👤 User: $CURRENT_USER
🖥 System: $SYSTEM_NAME
🌐 IP: $IP_ADDRESS
🕒 Time: $(date)
Attempts: 3

Access Blocked." \
            >/dev/null 2>&1
            exit 1
        fi
    fi
done