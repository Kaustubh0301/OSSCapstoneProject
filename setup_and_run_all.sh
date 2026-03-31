#!/bin/bash
# =============================================================
# Setup and Run All Scripts
# Description: This script installs all necessary dependencies
#   and then runs each of the 5 capstone project scripts one
#   by one. Designed for Ubuntu/Debian (including WSL).
#   Run this script ONCE and it handles everything.
#
# Usage:
#   chmod +x setup_and_run_all.sh
#   sudo ./setup_and_run_all.sh
#
# Note: Needs sudo because it installs packages via apt.
# =============================================================

# --- Colors for better readability ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color (reset)

# --- Get the directory where this script lives ---
# All other scripts should be in the same folder
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Check if running with sudo/root ---
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[!] Please run this script with sudo:${NC}"
    echo "    sudo ./setup_and_run_all.sh"
    exit 1
fi

# --- Store the actual user (not root) for later use ---
# When you run with sudo, $USER becomes root, but SUDO_USER
# keeps the original username
ACTUAL_USER=${SUDO_USER:-$USER}

echo ""
echo -e "${BLUE}=============================================="
echo "   OSS Capstone Project - Setup & Run All"
echo "==============================================${NC}"
echo ""

# =============================================================
# PHASE 1: INSTALL DEPENDENCIES
# =============================================================
echo -e "${YELLOW}[PHASE 1] Installing dependencies...${NC}"
echo ""

# Update package list first
echo -e "${GREEN}[*] Updating package list...${NC}"
apt update -y 2>/dev/null

# List of packages we need across all 5 scripts
# git        -> Script 2 needs it to inspect, Script 3 checks its config
# coreutils  -> provides du, ls, whoami, date, etc. (usually pre-installed)
# grep       -> used in Scripts 2 and 4 (usually pre-installed)
# util-linux -> provides uptime (usually pre-installed)
PACKAGES=("git" "coreutils" "grep" "util-linux")

for PKG in "${PACKAGES[@]}"; do
    # check if already installed using dpkg
    if dpkg -s "$PKG" &>/dev/null; then
        echo -e "${GREEN}[+] $PKG is already installed.${NC}"
    else
        echo -e "${YELLOW}[*] Installing $PKG...${NC}"
        apt install -y "$PKG" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[+] $PKG installed successfully.${NC}"
        else
            echo -e "${RED}[-] Failed to install $PKG. Continuing anyway...${NC}"
        fi
    fi
done

echo ""
echo -e "${GREEN}[+] All dependencies handled.${NC}"
echo ""

# =============================================================
# PHASE 2: MAKE ALL SCRIPTS EXECUTABLE
# =============================================================
echo -e "${YELLOW}[PHASE 2] Making all scripts executable...${NC}"
echo ""

chmod +x "$SCRIPT_DIR"/script1_system_identity.sh
chmod +x "$SCRIPT_DIR"/script2_package_inspector.sh
chmod +x "$SCRIPT_DIR"/script3_disk_permission_auditor.sh
chmod +x "$SCRIPT_DIR"/script4_log_analyzer.sh
chmod +x "$SCRIPT_DIR"/script5_manifesto_generator.sh

echo -e "${GREEN}[+] All scripts are now executable.${NC}"
echo ""

# =============================================================
# PHASE 3: CREATE A SAMPLE LOG FILE FOR SCRIPT 4
# =============================================================
# Script 4 needs a log file to analyze. Real log files might
# need root access or might not exist on a fresh WSL install,
# so we create a realistic sample log file to guarantee it works.
echo -e "${YELLOW}[PHASE 3] Creating sample log file for Script 4...${NC}"
echo ""

SAMPLE_LOG="$SCRIPT_DIR/sample_system.log"

cat > "$SAMPLE_LOG" << 'LOGEOF'
Mar 30 08:01:12 ubuntu systemd[1]: Starting Daily apt download activities...
Mar 30 08:01:15 ubuntu systemd[1]: Started Daily apt download activities.
Mar 30 08:05:33 ubuntu kernel: [42031.221] USB device connected
Mar 30 08:12:44 ubuntu sshd[2201]: WARNING: Failed password for admin from 192.168.1.105
Mar 30 08:12:45 ubuntu sshd[2201]: error: PAM authentication failure for admin
Mar 30 08:15:01 ubuntu CRON[2234]: (root) CMD (command -v debian-sa1 > /dev/null)
Mar 30 08:22:17 ubuntu kernel: [43102.556] error: ata1: device not ready
Mar 30 08:30:00 ubuntu systemd[1]: Starting System Logging Service...
Mar 30 08:30:01 ubuntu rsyslogd: rsyslogd started
Mar 30 08:45:12 ubuntu nginx[891]: 200 GET /index.html 192.168.1.50
Mar 30 08:45:13 ubuntu nginx[891]: 404 GET /missing-page.html 192.168.1.51
Mar 30 08:50:22 ubuntu kernel: [44831.009] WARNING: CPU temperature above threshold
Mar 30 09:01:00 ubuntu systemd[1]: Started Daily Cleanup of Temporary Directories.
Mar 30 09:15:33 ubuntu sshd[2401]: Accepted publickey for developer from 10.0.0.5
Mar 30 09:22:11 ubuntu sudo: developer : TTY=pts/0 ; PWD=/home/developer ; COMMAND=/bin/apt update
Mar 30 09:30:44 ubuntu kernel: [47299.112] error: Buffer I/O error on device sdb1
Mar 30 09:35:00 ubuntu mysql[1102]: WARNING: Aborted connection 14 to db: 'appdb'
Mar 30 09:40:12 ubuntu systemd[1]: Starting Apache HTTP Server...
Mar 30 09:40:15 ubuntu apache2[1201]: Server configured, listening on port 80
Mar 30 09:55:01 ubuntu kernel: [48700.331] Out of memory: Killed process 1455 (java)
Mar 30 10:00:00 ubuntu CRON[2500]: (root) CMD (/usr/lib/apt/apt.systemd.daily)
Mar 30 10:10:22 ubuntu sshd[2601]: error: Connection closed by 192.168.1.200 [preauth]
Mar 30 10:15:33 ubuntu kernel: [49888.442] WARNING: possible circular locking dependency detected
Mar 30 10:22:45 ubuntu nginx[891]: error: upstream timed out (110: Connection timed out)
Mar 30 10:30:11 ubuntu systemd[1]: Stopping User Manager for UID 1001...
Mar 30 10:30:15 ubuntu systemd[1]: Stopped User Manager for UID 1001.
Mar 30 10:45:00 ubuntu mysql[1102]: error: Table 'appdb.sessions' doesn't exist
Mar 30 11:00:22 ubuntu kernel: [52877.556] error: EXT4-fs error: unable to read inode block
Mar 30 11:05:33 ubuntu sshd[2801]: WARNING: Weak host key algorithm negotiated
Mar 30 11:15:44 ubuntu systemd[1]: Starting Cleanup of Temporary Directories...
Mar 30 11:20:00 ubuntu rsyslogd: WARNING: large message size 4096 bytes
LOGEOF

# make it readable by non-root users too
chmod 644 "$SAMPLE_LOG"

echo -e "${GREEN}[+] Sample log file created at: $SAMPLE_LOG${NC}"
echo ""

# =============================================================
# PHASE 4: RUN ALL SCRIPTS ONE BY ONE
# =============================================================
echo -e "${YELLOW}[PHASE 4] Running all scripts...${NC}"
echo ""

# --- Helper function to add a pause between scripts ---
pause_between() {
    echo ""
    echo -e "${BLUE}----------------------------------------------${NC}"
    echo -e "${BLUE}  Press ENTER to continue to the next script  ${NC}"
    echo -e "${BLUE}  (Take a screenshot now if you need one!)    ${NC}"
    echo -e "${BLUE}----------------------------------------------${NC}"
    # read from terminal directly (not stdin), run as actual user
    read -r < /dev/tty
    echo ""
}

# ---- SCRIPT 1 ----
echo -e "${GREEN}=============================================="
echo "  RUNNING: Script 1 - System Identity Report"
echo "==============================================${NC}"
echo ""
# run as actual user (not root) for accurate whoami output
su - "$ACTUAL_USER" -c "bash '$SCRIPT_DIR/script1_system_identity.sh'"
pause_between

# ---- SCRIPT 2 ----
echo -e "${GREEN}=============================================="
echo "  RUNNING: Script 2 - FOSS Package Inspector"
echo "==============================================${NC}"
echo ""
su - "$ACTUAL_USER" -c "bash '$SCRIPT_DIR/script2_package_inspector.sh'"
pause_between

# ---- SCRIPT 3 ----
echo -e "${GREEN}=============================================="
echo "  RUNNING: Script 3 - Disk and Permission Auditor"
echo "==============================================${NC}"
echo ""
# this one benefits from root access for du on restricted dirs
bash "$SCRIPT_DIR/script3_disk_permission_auditor.sh"
pause_between

# ---- SCRIPT 4 ----
echo -e "${GREEN}=============================================="
echo "  RUNNING: Script 4 - Log File Analyzer"
echo "==============================================${NC}"
echo ""
echo -e "${YELLOW}  Running with sample log file, keyword 'error'${NC}"
echo ""
su - "$ACTUAL_USER" -c "bash '$SCRIPT_DIR/script4_log_analyzer.sh' '$SAMPLE_LOG' error"
echo ""
echo -e "${YELLOW}  Running again with keyword 'WARNING'${NC}"
echo ""
su - "$ACTUAL_USER" -c "bash '$SCRIPT_DIR/script4_log_analyzer.sh' '$SAMPLE_LOG' WARNING"
pause_between

# ---- SCRIPT 5 ----
echo -e "${GREEN}=============================================="
echo "  RUNNING: Script 5 - Open Source Manifesto Generator"
echo "==============================================${NC}"
echo ""
echo -e "${YELLOW}  This script is INTERACTIVE -- answer the 3 questions!${NC}"
echo ""
su - "$ACTUAL_USER" -c "cd '$SCRIPT_DIR' && bash '$SCRIPT_DIR/script5_manifesto_generator.sh'" < /dev/tty

echo ""
echo ""
echo -e "${BLUE}=============================================="
echo "=============================================="
echo "       ALL SCRIPTS COMPLETED SUCCESSFULLY"
echo "==============================================${NC}"
echo ""
echo -e "${GREEN}  Files created:${NC}"
echo "    - Sample log file: $SAMPLE_LOG"

# check if manifesto was created
MANIFESTO="$SCRIPT_DIR/manifesto_${ACTUAL_USER}.txt"
if [ -f "$MANIFESTO" ]; then
    echo "    - Manifesto file : $MANIFESTO"
fi

echo ""
echo -e "${YELLOW}  NEXT STEPS:${NC}"
echo "    1. Take screenshots of each script's output"
echo "    2. Paste them into the Word report"
echo "    3. Fill in your name and reg number in the report"
echo "    4. Fill in your name in each .sh file"
echo "    5. Convert report to PDF for submission"
echo ""
echo -e "${BLUE}==============================================${NC}"
echo ""
