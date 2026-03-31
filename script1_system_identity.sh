#!/bin/bash
# =============================================================
# Script 1: System Identity Report
# Author: [Your Name] | Course: Open Source Software
# Description: This script acts like a welcome screen for the
#   Linux system. It pulls basic system info and displays it
#   in a neat, formatted way. Think of it as a quick snapshot
#   of who you are on this machine and what's running under
#   the hood.
# Concepts used: variables, echo, command substitution ($()),
#   basic output formatting, conditional checks
# =============================================================

# --- Student and project details ---
STUDENT_NAME="[Your Name]"          # fill in your actual name
SOFTWARE_CHOICE="Git"               # the OSS project I picked for this audit

# --- Gathering system information using command substitution ---
# uname -r gives just the kernel release version (e.g. 5.15.0-91-generic)
KERNEL=$(uname -r)

# whoami returns the username of whoever is running this script
USER_NAME=$(whoami)

# the $HOME variable is set by the shell automatically on login
HOME_DIR=$HOME

# uptime -p gives a human-readable uptime like "up 3 hours, 12 minutes"
UPTIME=$(uptime -p)

# date command with formatting -- %A gives day name, %d %B %Y gives the full date
CURRENT_DATE=$(date '+%A, %d %B %Y')
CURRENT_TIME=$(date '+%H:%M:%S')

# trying to grab the distro name from os-release, which most modern distros have
# if it doesn't exist for some reason, we fall back to "Unknown"
if [ -f /etc/os-release ]; then
    # source the file so we can use its variables directly
    . /etc/os-release
    DISTRO_NAME=$NAME
    DISTRO_VERSION=$VERSION
else
    DISTRO_NAME="Unknown"
    DISTRO_VERSION="N/A"
fi

# --- Display everything in a formatted layout ---
echo "=============================================="
echo "     Open Source Audit - System Identity       "
echo "         Student: $STUDENT_NAME                "
echo "=============================================="
echo ""
echo "  Software being audited : $SOFTWARE_CHOICE"
echo ""
echo "----------------------------------------------"
echo "  SYSTEM DETAILS"
echo "----------------------------------------------"
echo "  Distribution   : $DISTRO_NAME $DISTRO_VERSION"
echo "  Kernel Version : $KERNEL"
echo "  Logged-in User : $USER_NAME"
echo "  Home Directory : $HOME_DIR"
echo "  System Uptime  : $UPTIME"
echo "  Date           : $CURRENT_DATE"
echo "  Time           : $CURRENT_TIME"
echo "----------------------------------------------"
echo ""

# --- License message about the OS ---
# Most Linux distros are built on the Linux kernel which is GPL v2
# so this message is accurate for pretty much any standard distro
echo "  LICENSE NOTE:"
echo "  The Linux kernel powering this system is licensed"
echo "  under the GNU General Public License version 2 (GPL v2)."
echo "  This means anyone can view, modify, and redistribute"
echo "  the source code, as long as derivative works also"
echo "  remain under GPL v2."
echo ""
echo "=============================================="
echo "  Report generated at $CURRENT_TIME on $CURRENT_DATE"
echo "=============================================="
