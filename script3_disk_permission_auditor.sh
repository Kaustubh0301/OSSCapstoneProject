#!/bin/bash
# =============================================================
# Script 3: Disk and Permission Auditor
# Author: [Your Name] | Course: Open Source Software
# Description: Loops through a list of important system
#   directories and reports the disk space used, plus the
#   owner and permissions of each directory. Also checks
#   whether Git's config directory exists and shows its perms.
# Concepts used: for loop, arrays, du, ls -ld, awk/cut for
#   field extraction, if-else for existence checks
# =============================================================

# --- List of important system directories to audit ---
# These are standard Linux directories that any sysadmin
# should know about and monitor
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/share" "/opt")

echo "=============================================="
echo "       Disk and Permission Auditor"
echo "=============================================="
echo ""
echo "Date: $(date '+%d %B %Y, %H:%M:%S')"
echo ""

# --- Column headers for the report ---
# using printf for alignment because echo doesn't pad well
printf "%-20s %-25s %-10s\n" "DIRECTORY" "PERMISSIONS (mode owner grp)" "SIZE"
echo "---------------------------------------------------------------"

# --- Loop through each directory in our list ---
for DIR in "${DIRS[@]}"; do
    # first check if the directory actually exists on this system
    if [ -d "$DIR" ]; then
        # ls -ld shows details of the directory itself (not its contents)
        # awk pulls out: $1 = permissions, $3 = owner, $4 = group
        PERMS=$(ls -ld "$DIR" | awk '{print $1, $3, $4}')

        # du -sh gives a human-readable size summary
        # 2>/dev/null suppresses "permission denied" errors on restricted dirs
        # cut -f1 grabs just the size part (before the tab)
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        # if du fails (permissions issue), show a placeholder
        if [ -z "$SIZE" ]; then
            SIZE="N/A (restricted)"
        fi

        printf "%-20s %-25s %-10s\n" "$DIR" "$PERMS" "$SIZE"
    else
        # directory doesn't exist -- not unusual, some dirs are distro-specific
        printf "%-20s %-25s %-10s\n" "$DIR" "[does not exist]" "-"
    fi
done

echo ""
echo "---------------------------------------------------------------"
echo ""

# --- Special check: Git configuration directory ---
# Git stores its global config in ~/.gitconfig or ~/.config/git/
# and each repo has a .git/ directory. Let's check the global one.
echo "Checking Git configuration locations..."
echo ""

GIT_GLOBAL_CONFIG="$HOME/.gitconfig"
GIT_CONFIG_DIR="$HOME/.config/git"
GIT_SYSTEM_CONFIG="/etc/gitconfig"

# check the global gitconfig file
if [ -f "$GIT_GLOBAL_CONFIG" ]; then
    PERMS=$(ls -l "$GIT_GLOBAL_CONFIG" | awk '{print $1, $3, $4}')
    SIZE=$(du -h "$GIT_GLOBAL_CONFIG" 2>/dev/null | cut -f1)
    echo "  ~/.gitconfig found"
    echo "    Permissions: $PERMS"
    echo "    Size: $SIZE"
else
    echo "  ~/.gitconfig not found (maybe git hasn't been configured yet)"
fi

echo ""

# check the XDG-style config directory
if [ -d "$GIT_CONFIG_DIR" ]; then
    PERMS=$(ls -ld "$GIT_CONFIG_DIR" | awk '{print $1, $3, $4}')
    echo "  ~/.config/git/ directory found"
    echo "    Permissions: $PERMS"
else
    echo "  ~/.config/git/ directory not found"
fi

echo ""

# system-wide git config
if [ -f "$GIT_SYSTEM_CONFIG" ]; then
    PERMS=$(ls -l "$GIT_SYSTEM_CONFIG" | awk '{print $1, $3, $4}')
    echo "  /etc/gitconfig (system-wide) found"
    echo "    Permissions: $PERMS"
else
    echo "  /etc/gitconfig (system-wide) not found"
fi

echo ""
echo "=============================================="
echo "  Audit complete."
echo "=============================================="
