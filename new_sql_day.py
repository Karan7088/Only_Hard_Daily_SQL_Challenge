import os
import re
import datetime
import subprocess

# -------- CONFIG --------
BASE_DIR = r"C:\Users\aswal\OneDrive\Desktop\Only_Hard_Daily_SQL_Challenge"
REPO_LINK = "https://github.com/Karan7088/Only_Hard_Daily_SQL_Challenge"

# -------- MOVE TO REPO --------
os.chdir(BASE_DIR)

# -------- FIND LAST DAY --------
folders = os.listdir(BASE_DIR)

days = []

for f in folders:
    match = re.search(r"DAY(\d+)_", f)
    if match:
        days.append(int(match.group(1)))

if len(days) == 0:
    next_day = 1
else:
    next_day = max(days) + 1

# -------- GET TODAY DATE --------
today = datetime.date.today().strftime("%Y-%m-%d")

# -------- CREATE FOLDER --------
folder_name = f"DAY{next_day}_{today}_problem"
folder_path = os.path.join(BASE_DIR, folder_name)

os.makedirs(folder_path, exist_ok=True)

print("✅ Created Folder:", folder_name)

# -------- CREATE FILES --------
files = [
    "README.md",
    "schema.sql",
    "data.sql",
    "solution.sql",
    "expected_output.md"
]

for file in files:
    file_path = os.path.join(folder_path, file)

    with open(file_path, "w") as f:
        f.write(" ")  # prevents git from ignoring empty files

print("✅ Files Created")

# -------- GIT COMMANDS --------
try:

    subprocess.run("git add .", shell=True, check=True)

    subprocess.run(
        f'git commit -m "commited day {next_day}"',
        shell=True,
        check=True
    )

    subprocess.run(
        "git pull origin main --rebase",
        shell=True,
        check=True
    )

    subprocess.run(
        "git push origin main",
        shell=True,
        check=True
    )

    print("🚀 Successfully pushed to GitHub")

except subprocess.CalledProcessError:
    print("⚠️ Git operation failed. Check terminal output.")

# -------- LINKEDIN POST --------
problem_link = f"{REPO_LINK}/tree/main/{folder_name}"

post = f"""
🚀 Day {next_day} – Only Hard SQL Challenge

Try solving today's SQL problem:

{problem_link}

#SQL #DataAnalytics #DataEngineering #SQLChallenge
"""

print("\n📢 LinkedIn Post Template:\n")
print(post)