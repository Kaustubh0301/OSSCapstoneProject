#!/bin/bash
# =============================================================
# Script 2: FOSS Package Inspector
# Author: [Your Name] | Course: Open Source Software
# Description: Checks whether Git (or other FOSS packages) is
#   installed on the system, grabs its version info, and uses
#   a case statement to print a short philosophy note about
#   each package. Handy for quickly verifying what's on your
#   system and understanding what each tool stands for.
# Concepts used: if-then-else, case statement, command checking
#   with 'which', dpkg/rpm for package details, piping with grep
# =============================================================

# --- The package we're auditing ---
PACKAGE="git"    # my chosen software for this capstone project

# --- Function to check if a command exists on the system ---
# using 'which' because it searches the PATH for the binary
check_installed() {
    if which "$1" > /dev/null 2>&1; then
        return 0   # 0 means success/true in bash
    else
        return 1   # non-zero means failure/false
    fi
}

echo "=============================================="
echo "       FOSS Package Inspector"
echo "=============================================="
echo ""

# --- Check if the package is installed ---
if check_installed "$PACKAGE"; then
    echo "[+] $PACKAGE is INSTALLED on this system."
    echo ""

    # grab the version -- git has its own --version flag
    VERSION=$($PACKAGE --version 2>/dev/null)
    echo "    Version: $VERSION"
    echo ""

    # try to get more details using dpkg (Debian/Ubuntu) or rpm (RHEL/Fedora)
    # not every system has both, so we check which one is available
    if which dpkg > /dev/null 2>&1; then
        echo "    Package details (from dpkg):"
        # dpkg -s gives status info, we grep for the useful fields
        dpkg -s "$PACKAGE" 2>/dev/null | grep -E 'Version|Maintainer|Description' | head -5
    elif which rpm > /dev/null 2>&1; then
        echo "    Package details (from rpm):"
        # rpm -qi gives full query info
        rpm -qi "$PACKAGE" 2>/dev/null | grep -E 'Version|License|Summary'
    else
        echo "    (Neither dpkg nor rpm found -- can't pull package metadata)"
    fi
else
    # package isn't installed -- let the user know how to get it
    echo "[-] $PACKAGE is NOT installed on this system."
    echo ""
    echo "    To install it, try one of these:"
    echo "      sudo apt install $PACKAGE      (Debian/Ubuntu)"
    echo "      sudo dnf install $PACKAGE      (Fedora/RHEL)"
    echo "      sudo pacman -S $PACKAGE        (Arch)"
fi

echo ""
echo "----------------------------------------------"
echo "  Philosophy Notes"
echo "----------------------------------------------"

# --- Case statement for philosophy notes about different FOSS tools ---
# This shows understanding of what each project represents beyond
# just its technical function
case $PACKAGE in
    git)
        echo "  Git: Born out of necessity when a proprietary tool"
        echo "  failed the Linux community. Linus Torvalds built it"
        echo "  in 2005 and it changed how the whole world collaborates"
        echo "  on code. It proves that open source can replace"
        echo "  proprietary tools when the community needs it to."
        ;;
    httpd|apache2)
        echo "  Apache: The web server that basically built the open"
        echo "  internet. Without Apache, the early web would have"
        echo "  been controlled by a handful of companies."
        ;;
    mysql|mysql-server)
        echo "  MySQL: Started as a genuinely open project, then got"
        echo "  acquired by Oracle. The community forked it into"
        echo "  MariaDB -- a perfect example of how open source"
        echo "  licenses protect users from corporate takeovers."
        ;;
    firefox)
        echo "  Firefox: A nonprofit browser fighting against the"
        echo "  dominance of Chrome. It stands for user privacy"
        echo "  and an open web that isn't controlled by ad companies."
        ;;
    vlc)
        echo "  VLC: Built by students at Ecole Centrale Paris who"
        echo "  just wanted to stream video across their campus."
        echo "  Now it plays literally anything you throw at it."
        ;;
    python|python3)
        echo "  Python: A language designed for readability and shaped"
        echo "  entirely by its community through PEPs. Proof that"
        echo "  open governance can produce something beautiful."
        ;;
    *)
        echo "  No philosophy note available for '$PACKAGE'."
        echo "  But every FOSS tool has a story worth knowing."
        ;;
esac

echo ""
echo "=============================================="
