import os
import re
import datetime
import subprocess

BASE_DIR = r"C:\Users\aswal\OneDrive\Desktop\Only_Hard_Daily_SQL_Challenge"

# move to repo
os.chdir(BASE_DIR)

# ---------- find last day ----------
folders = os.listdir(BASE_DIR)
days = []

for f in folders:
    match = re.search(r"DAY(\d+)_", f)
    if match:
        days.append(int(match.group(1)))

next_day = max(days) + 1 if days else 1
today = datetime.date.today().strftime("%Y-%m-%d")

folder_name = f"DAY{next_day}_{today}_problem"
folder_path = os.path.join(BASE_DIR, folder_name)

# ---------- create folder ----------
os.makedirs(folder_path)

# ---------- create files ----------
files = [
    "README.md",
    "schema.sql",
    "data.sql",
    "solution.sql",
    "expected_output.md"
]

for file in files:
    with open(os.path.join(folder_path, file), "w") as f:
        f.write(" ")

print("Folder Created:", folder_name)

# ---------- GIT COMMANDS ----------
subprocess.run("git add .", shell=True)
subprocess.run(f'git commit -m "commited day {next_day}"', shell=True)
subprocess.run("git push origin main", shell=True)

print("Pushed to GitHub successfully")