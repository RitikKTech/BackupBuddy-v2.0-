# BackupBuddy — Automated Backup with Email + Telegram Alerts & Web Dashboard

**BackupBuddy** is a Linux automation project that performs system folder backups, sends real-time alerts via Gmail and Telegram, and displays logs through a Flask-based web dashboard.  
It’s built for reliability, visibility, and real-world automation — perfect for DevOps learners and system admins.

---

## 🚀 Key Features

✅ Backup any folder as a `.tar.gz` archive  
📩 Send **Gmail alerts** when backup succeeds or fails  
📲 Instant **Telegram alerts** with status  
🌐 View backup history via **Flask web dashboard**  
📝 Logs everything in `logs/backup.log`  
💡 Lightweight: Pure Bash + Python + curl + Flask  
🔒 Secrets are stored securely in `.env` or `config.ini`  

---

## 🎯 Real-World Use Case

- ✅ Job/Interview projects for DevOps roles  
- ✅ Server backup monitoring on Linux systems  
- ✅ Multi-channel alert systems (email + Telegram)  
- ✅ Flask dashboard + Bash integration example

---

## 📁 Folder Structure

backupbuddy/
├── backupbuddy.sh # Main backup + alert script (Bash)
├── app.py # Flask web dashboard to view logs
├── config.ini # Telegram & Gmail config (dummy)
├── logs/ # All backup log files
├── backups/ # Stored .tar.gz backup archives
├── templates/ # Flask HTML template (dashboard)
└── README.md # This file


---

## ⚙️ How to Use

### 1️⃣ Clone the Repo

```bash
git clone https://github.com/<your-username>/BackupBuddy.git
cd BackupBuddy

2️⃣ Setup Gmail + Telegram
📧 Gmail Alert Setup

Create an App Password and use it in .env or config.ini:

[email]
sender = youremail@gmail.com
password = your_gmail_app_password

Telegram Alert Setup

    Create bot from @BotFather

    Copy your BOT_TOKEN

    Send a message to the bot → get chat_id from:

https://api.telegram.org/bot<YourToken>/getUpdates

[telegram]
bot_token = your_bot_token
chat_id = your_chat_id


Run Backup Script

bash backupbuddy.sh

    It will compress your folder, log the result, and send alerts.


4️⃣ Run the Web Dashboard

python3 app.py

Then open in browser:

http://localhost:5000

You’ll see backup history, timestamps, and logs in real-time!


Dashboard Preview
## 📸 Dashboard Preview

![Dashboard Screenshot](https://github.com/RitikKTech/BackupBuddy/commit/abe66a90625497dd01a1364c5c5b07d0b17b2b16)

Security Best Practices

This repo uses .gitignore to keep sensitive files safe:

.env
config.ini
venv/
__pycache__/
*.log
*.pyc

    Never commit real credentials to GitHub.



Roadmap (v2.0 Preview)

    ☁️ Cloud storage upload (gofile.io / AWS S3)

    🧠 Backup filtering on dashboard

    🕒 Scheduled auto-backups via crontab

    🧪 Test mode / dry run support

    🧑‍💻 Admin authentication for dashboard

👨‍💻 Author

Made with 💻 by Ritik Rajbhar
Feel free to fork, modify, or contribute!

License

MIT License — free for educational, personal, or professional use.

    Don’t forget to star the repo if you like it!


---

## ✅ Next Step:

1. Replace old `README.md` with this one
2. Run:
```bash
git add README.md
git commit -m "Update README.md for Gmail + Telegram + Flask dashboard"
git push
