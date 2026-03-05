import os
import re
import datetime
import subprocess

BASE_DIR = r"C:\Users\aswal\OneDrive\Desktop\Only_Hard_Daily_SQL_Challenge"
REPO_LINK = "https://github.com/Karan7088/Only_Hard_Daily_SQL_Challenge"

# find last day
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

# create folder
os.makedirs(folder_path)

# create files
files = [
    "README.md",
    "schema.sql",
    "data.sql",
    "solution.sql",
    "expected_output.md"
]

for file in files:
    open(os.path.join(folder_path, file), "w").close()

print("✅ Folder Created:", folder_name)

# ---------- GIT AUTOMATION ----------
os.chdir(BASE_DIR)

subprocess.run(["git", "add", "."])
subprocess.run(["git", "commit", "-m", f"commited day {next_day}"])
subprocess.run(["git", "push"])

print("✅ Code pushed to GitHub")

# ---------- LinkedIn Post ----------
problem_link = f"{REPO_LINK}/tree/main/{folder_name}"

post = f"""
🚀 Day {next_day} – Only Hard SQL Challenge

Try solving today's SQL problem:
{problem_link}

#SQL #DataAnalytics #SQLChallenge
"""

print("\nLinkedIn Post:\n")
print(post)