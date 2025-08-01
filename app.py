from flask import Flask, render_template_string, request, redirect, url_for
import os
import subprocess

app = Flask(__name__)

BACKUP_DIR = "/home/ritik/backupbuddy/backups"
LOG_FILE = "/home/ritik/backupbuddy/logs/backupbuddy.log"
SCRIPT_PATH = "/home/ritik/backupbuddy/backupbuddy.sh"

@app.route("/")
def dashboard():
    # Get recent backups
    if os.path.exists(BACKUP_DIR):
        backups = sorted(os.listdir(BACKUP_DIR), reverse=True)[:5]
    else:
        backups = ["Backup folder not found"]

    # Get latest logs
    if os.path.exists(LOG_FILE):
        with open(LOG_FILE, "r") as f:
            logs = f.read().splitlines()[-10:]
    else:
        logs = ["Log file not found"]

    return render_template_string("""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <title>📦 BackupBuddy Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body { background-color: #f8f9fa; padding: 30px; }
            .card { margin-bottom: 20px; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1 class="mb-4">📦 BackupBuddy Dashboard</h1>

            <div class="card">
                <div class="card-header bg-primary text-white">🗂 Recent Backups</div>
                <div class="card-body">
                    <ul class="list-group">
                        {% for b in backups %}
                        <li class="list-group-item">{{ b }}</li>
                        {% endfor %}
                    </ul>
                </div>
            </div>

            <div class="card">
                <div class="card-header bg-secondary text-white">📝 Latest Logs</div>
                <div class="card-body">
                    <pre class="bg-light p-3">{{ logs|join("\\n") }}</pre>
                </div>
            </div>

            <form method="POST" action="/run-backup">
                <button type="submit" class="btn btn-success mt-3">▶️ Run Backup Now</button>
            </form>
        </div>
    </body>
    </html>
    """, backups=backups, logs=logs)


@app.route("/run-backup", methods=["POST"])
def run_backup():
    try:
        result = subprocess.check_output(["bash", SCRIPT_PATH], stderr=subprocess.STDOUT)
        message = result.decode("utf-8")
    except subprocess.CalledProcessError as e:
        message = f"❌ Backup failed:\n{e.output.decode('utf-8')}"

    return render_template_string("""
    <html>
    <head><title>📦 BackupBuddy - Result</title></head>
    <body style="font-family: sans-serif; padding: 30px;">
        <h2>📦 Backup Result</h2>
        <pre style="background-color: #eee; padding: 20px;">{{ message }}</pre>
        <a href="/" style="display: inline-block; margin-top: 20px;">⬅️ Back to Dashboard</a>
    </body>
    </html>
    """, message=message)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
 
