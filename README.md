# OSS Capstone Project

A collection of five Bash scripts developed as part of the **Open Source Software** course capstone project. The scripts demonstrate core Linux/Bash concepts while performing practical system administration and open-source auditing tasks, with **Git** as the chosen FOSS project for analysis.

## Project Structure

```
scripts/
├── setup_and_run_all.sh              # Master script - installs dependencies & runs all scripts
├── script1_system_identity.sh        # System Identity Report
├── script2_package_inspector.sh      # FOSS Package Inspector
├── script3_disk_permission_auditor.sh # Disk and Permission Auditor
├── script4_log_analyzer.sh           # Log File Analyzer
├── script5_manifesto_generator.sh    # Open Source Manifesto Generator
├── sample_system.log                 # Sample log file for Script 4
└── manifesto_root.txt                # Sample generated manifesto output
```

## Scripts Overview

### Script 1: System Identity Report
Displays a snapshot of the current system including distribution name, kernel version, logged-in user, home directory, uptime, and date/time. Also prints a note about the GPL v2 license that powers the Linux kernel.

**Concepts:** Variables, `echo`, command substitution (`$()`), conditional checks, output formatting.

### Script 2: FOSS Package Inspector
Checks whether Git (or other FOSS packages) is installed, retrieves version and package metadata via `dpkg`/`rpm`, and uses a `case` statement to print a philosophy note about the inspected package.

**Concepts:** `if-then-else`, `case` statement, command checking with `which`, `dpkg`/`rpm` queries, piping with `grep`.

### Script 3: Disk and Permission Auditor
Loops through important system directories (`/etc`, `/var/log`, `/home`, `/usr/bin`, `/tmp`, `/usr/share`, `/opt`) and reports disk usage, ownership, and permissions. Also audits Git configuration file locations (`~/.gitconfig`, `~/.config/git/`, `/etc/gitconfig`).

**Concepts:** `for` loop, arrays, `du`, `ls -ld`, `awk`/`cut` for field extraction, `if-else` existence checks.

### Script 4: Log File Analyzer
Reads a log file line by line, counts occurrences of a given keyword (default: `error`), and prints a summary with the last 5 matching lines. Includes retry logic for empty files.

**Concepts:** `while-read` loop, command-line arguments (`$1`, `$2`), file existence checks, counter variables, retry logic, `tail` + `grep`.

**Usage:**
```bash
./script4_log_analyzer.sh <logfile> [keyword]
# Example:
./script4_log_analyzer.sh sample_system.log error
```

### Script 5: Open Source Manifesto Generator
An interactive script that asks three questions about the user's relationship with open source, then composes a personalised philosophy statement and saves it to `manifesto_<username>.txt`.

**Concepts:** `read` for user input, string concatenation, file writing with `>` and `>>`, `date` command, aliases concept.

## Prerequisites

- **OS:** Ubuntu/Debian-based Linux (including WSL on Windows)
- **Packages:** `git`, `coreutils`, `grep`, `util-linux` (most are pre-installed)

## Quick Start

The easiest way to run everything is through the master setup script, which installs dependencies and executes all five scripts sequentially:

```bash
chmod +x scripts/setup_and_run_all.sh
sudo ./scripts/setup_and_run_all.sh
```

The master script will:
1. Install all required dependencies via `apt`
2. Make all scripts executable
3. Create a sample log file for Script 4
4. Run each script one by one (with pauses between them for screenshots)

### Running Scripts Individually

```bash
cd scripts
chmod +x *.sh

# Script 1 - no arguments needed
./script1_system_identity.sh

# Script 2 - no arguments needed
./script2_package_inspector.sh

# Script 3 - benefits from root access
sudo ./script3_disk_permission_auditor.sh

# Script 4 - requires a log file path and optional keyword
./script4_log_analyzer.sh sample_system.log error

# Script 5 - interactive, will prompt for input
./script5_manifesto_generator.sh
```

## License

This project is developed for educational purposes as part of the Open Source Software course curriculum.
