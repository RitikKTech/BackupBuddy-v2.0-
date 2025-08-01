#!/bin/bash

# === Configuration ===
CONFIG_FILE="$HOME/backupbuddy/config.json"
DATE=$(date +%Y-%m-%d_%H-%M)
BACKUP_DIR="$HOME/backupbuddy/backups"
LOG_DIR="$HOME/backupbuddy/logs"
LOG_FILE="$LOG_DIR/backup-$DATE.log"
SOURCE_DIR="$HOME/Documents"
BACKUP_FILE="$BACKUP_DIR/backup-$DATE.tar.gz"

# Create required directories
mkdir -p "$BACKUP_DIR" "$LOG_DIR"

# === Load config using jq ===
EMAIL=$(jq -r '.email_receiver' "$CONFIG_FILE")
EMAIL_SENDER=$(jq -r '.email_sender' "$CONFIG_FILE")
EMAIL_PASS=$(jq -r '.email_password' "$CONFIG_FILE")
TELEGRAM_BOT_TOKEN=$(jq -r '.telegram_bot_token' "$CONFIG_FILE")
TELEGRAM_CHAT_ID=$(jq -r '.telegram_chat_id' "$CONFIG_FILE")
GOFILE_API_TOKEN=$(jq -r '.gofile_api_token' "$CONFIG_FILE")

# === Start logging ===
echo "=== Backup Started at $DATE ===" > "$LOG_FILE"

# === Create backup ===
if tar -czf "$BACKUP_FILE" "$SOURCE_DIR" 2>>"$LOG_FILE"; then
    echo "[$DATE] ✅ Backup created: $BACKUP_FILE" >> "$LOG_FILE"

    # === Upload to Gofile.io ===
    response=$(curl -s -X POST "https://upload.gofile.io/uploadFile" \
      -H "Authorization: Bearer $GOFILE_API_TOKEN" \
      -F "file=@$BACKUP_FILE")

    download_url=$(echo "$response" | grep -oP '(?<=\"downloadPage\":\")[^\"]+')

    if [ -n "$download_url" ]; then
        echo "[$DATE] ✅ Gofile.io upload successful: $download_url" >> "$LOG_FILE"

        # === Email Alert ===
        echo -e "Backup Successful at $DATE.\n\nDownload Link:\n$download_url" \
          | mail -s "BackupBuddy Success" "$EMAIL"

        # === Telegram Alert ===
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
             -d chat_id="$TELEGRAM_CHAT_ID" \
             -d text="✅ Backup Success on $(hostname) at $DATE%0ADownload Link:%0A$download_url"
    else
        echo "[$DATE] ❌ Gofile.io upload failed" >> "$LOG_FILE"
    fi

else
    echo "[$DATE] ❌ Backup failed" >> "$LOG_FILE"

    # === Failure Email Alert ===
    echo "Backup Failed at $DATE." \
      | mail -s "BackupBuddy Failed" "$EMAIL"

    # === Failure Telegram Alert ===
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
         -d chat_id="$TELEGRAM_CHAT_ID" \
         -d text="❌ Backup Failed on $(hostname) at $DATE"
fi

echo "=== Backup Finished ===" >> "$LOG_FILE"
