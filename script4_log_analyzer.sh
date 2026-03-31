#!/bin/bash
# =============================================================
# Script 4: Log File Analyzer
# Author: [Your Name] | Course: Open Source Software
# Usage: ./script4_log_analyzer.sh /var/log/syslog [keyword]
# Description: Reads a log file line by line, counts occurrences
#   of a keyword (default: "error"), and prints a summary along
#   with the last few matching lines. Useful for quick system
#   troubleshooting without opening the whole log in an editor.
# Concepts used: while-read loop, if-then, counter variables,
#   command-line arguments ($1, $2), file existence checks,
#   retry logic for empty files, tail + grep
# =============================================================

# --- Command-line arguments ---
# $1 is the log file path, $2 is the keyword to search for
LOGFILE=$1
KEYWORD=${2:-"error"}    # defaults to "error" if no keyword given
COUNT=0                  # counter for how many matches we find
TOTAL_LINES=0            # counter for total lines processed

# --- Validate that a file argument was provided ---
if [ -z "$LOGFILE" ]; then
    echo "Usage: $0 <logfile> [keyword]"
    echo "Example: $0 /var/log/syslog error"
    exit 1
fi

# --- Check if the file actually exists ---
if [ ! -f "$LOGFILE" ]; then
    echo "Error: File '$LOGFILE' not found."
    echo "Make sure the path is correct and you have read permissions."
    exit 1
fi

echo "=============================================="
echo "         Log File Analyzer"
echo "=============================================="
echo ""
echo "  File    : $LOGFILE"
echo "  Keyword : $KEYWORD"
echo ""

# --- Check if the file is empty and retry once ---
# This is the "do-while style retry" the project asks for
# Sometimes log files exist but are empty (just rotated, etc.)
ATTEMPT=1
MAX_ATTEMPTS=2

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    # -s checks if the file exists AND has a size greater than zero
    if [ -s "$LOGFILE" ]; then
        break   # file has content, proceed with analysis
    else
        echo "  Warning: File appears to be empty (attempt $ATTEMPT of $MAX_ATTEMPTS)"
        if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
            echo "  Waiting 2 seconds and retrying..."
            sleep 2
        else
            echo "  File is still empty after $MAX_ATTEMPTS attempts. Exiting."
            exit 1
        fi
    fi
    ATTEMPT=$((ATTEMPT + 1))
done

# --- Read through the file line by line ---
# IFS= prevents leading/trailing whitespace from being stripped
# -r prevents backslash interpretation
echo "  Scanning file..."
echo ""

while IFS= read -r LINE; do
    # increment total line counter
    TOTAL_LINES=$((TOTAL_LINES + 1))

    # grep -iq: -i for case-insensitive, -q for quiet (no output)
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))
    fi
done < "$LOGFILE"

# --- Print the summary ---
echo "----------------------------------------------"
echo "  RESULTS"
echo "----------------------------------------------"
echo "  Total lines scanned : $TOTAL_LINES"
echo "  Keyword '$KEYWORD' found : $COUNT times"
echo ""

# --- Calculate a rough percentage ---
if [ $TOTAL_LINES -gt 0 ]; then
    # bash doesn't do floating point, so multiply first then divide
    PERCENT=$(( (COUNT * 100) / TOTAL_LINES ))
    echo "  That's roughly ${PERCENT}% of all log lines."
fi

echo ""

# --- Show the last 5 matching lines using tail + grep ---
# This gives context about what the most recent issues are
echo "----------------------------------------------"
echo "  Last 5 lines containing '$KEYWORD':"
echo "----------------------------------------------"

# grep -i for case-insensitive, tail -5 for last 5 results
MATCHES=$(grep -i "$KEYWORD" "$LOGFILE" | tail -5)

if [ -n "$MATCHES" ]; then
    echo "$MATCHES"
else
    echo "  (no matching lines found)"
fi

echo ""
echo "=============================================="
echo "  Analysis complete."
echo "=============================================="
