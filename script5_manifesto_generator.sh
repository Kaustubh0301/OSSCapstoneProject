#!/bin/bash
# =============================================================
# Script 5: The Open Source Manifesto Generator
# Author: [Your Name] | Course: Open Source Software
# Description: An interactive script that asks the user three
#   questions about their relationship with open source, then
#   composes a personalised philosophy statement and saves it
#   to a text file. It's a creative exercise in string building
#   and user interaction through the terminal.
# Concepts used: read for user input, string concatenation,
#   writing to a file with > and >>, date command, aliases
#   concept (demonstrated via comment below)
# =============================================================

# --- About aliases ---
# In bash, an alias is a shortcut for a longer command. For example:
#   alias ll='ls -la'
#   alias gs='git status'
# You typically put these in ~/.bashrc so they load on every login.
# We're not setting aliases in this script because they don't carry
# over to subshells well, but the concept is: you can customize
# your terminal to match your workflow, which is very much in the
# spirit of open source -- making tools your own.

echo "=============================================="
echo "   The Open Source Manifesto Generator"
echo "=============================================="
echo ""
echo "Answer three questions and I'll generate a"
echo "personalised open source philosophy statement."
echo ""

# --- Question 1: A FOSS tool they use ---
read -p "1. Name one open-source tool you use every day: " TOOL

# --- Question 2: What freedom means to them ---
read -p "2. In one word, what does 'freedom' mean to you? " FREEDOM

# --- Question 3: What they would build and share ---
read -p "3. Name one thing you would build and share freely: " BUILD

echo ""

# --- Get the current date for the manifesto header ---
DATE=$(date '+%d %B %Y')

# --- Build the output filename using whoami ---
# each user gets their own manifesto file
OUTPUT="manifesto_$(whoami).txt"

# --- Compose the manifesto ---
# Using > for the first line (creates/overwrites the file)
# and >> for subsequent lines (appends to the file)
echo "========================================" > "$OUTPUT"
echo "  MY OPEN SOURCE MANIFESTO" >> "$OUTPUT"
echo "  Generated on $DATE" >> "$OUTPUT"
echo "  By: $(whoami)" >> "$OUTPUT"
echo "========================================" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# --- The actual manifesto paragraph ---
# Concatenating the user's answers into a flowing statement
echo "I believe in the power of open source software. Every day, I rely on $TOOL -- a tool that exists because someone chose to share their work with the world instead of locking it away. To me, freedom means $FREEDOM, and that is exactly what the open source movement represents. It is the idea that knowledge grows when it is shared, not when it is hoarded." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "If I could build one thing and give it away freely, it would be $BUILD. Not for recognition or profit, but because I know what it feels like to benefit from someone else's generosity. Every open source contributor before me made my work possible. The least I can do is pay it forward." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "Open source is not just a licensing model. It is a commitment to transparency, to collaboration, and to the belief that the best software is built by communities, not corporations. I stand on the shoulders of giants, and I hope to lift others up in return." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "--- End of Manifesto ---" >> "$OUTPUT"

# --- Confirm and display ---
echo "----------------------------------------------"
echo "  Manifesto saved to: $OUTPUT"
echo "----------------------------------------------"
echo ""

# display the generated manifesto back to the user
cat "$OUTPUT"

echo ""
echo "=============================================="
echo "  Share it. That's the whole point."
echo "=============================================="
