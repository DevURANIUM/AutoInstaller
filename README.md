# AutoInstaller 3.0.0

**AutoInstaller** is a Bash-based automation script designed to install and manage popular web hosting control panels and common server services through a simple interactive menu.

Version 3 improves security, validation, error handling, logging, and command-line usage without removing any of the existing interactive menu options.

It supports installation, configuration, and management of:

* cPanel
* Plesk
* aaPanel
* Server services (CSF, FTP, Web Server, Database, etc.)

## Table of Contents

* [Installation](#installation)
* [Command-Line Options](#command-line-options)
* [System Update Behavior](#system-update-behavior)
* [Supported Operating Systems](#supported-operating-systems)
* [Features](#features)

  * [cPanel](#cpanel)
  * [Plesk](#plesk)
  * [aaPanel](#aapanel)
* [Improvements](#improvements)
* [Security and Safety](#security-and-safety)
* [Logging and Troubleshooting](#logging-and-troubleshooting)
* [Support & Contributions](#support--contributions)
* [Donation Links](#donation-links)

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/DevURANIUM/AutoInstaller/
   ```

2. Navigate into the directory:

   ```bash
   cd AutoInstaller
   ```

3. Make the script executable:

   ```bash
   chmod +x autoinstaller.sh
   ```

4. Run the compatibility check:

   ```bash
   sudo ./autoinstaller.sh --check
   ```

5. Run the interactive installer as root:

   ```bash
   sudo ./autoinstaller.sh
   ```

Running the script through Bash is also supported:

```bash
sudo bash autoinstaller.sh
```

## Command-Line Options

```text
Usage: ./autoinstaller.sh [options]
  --check          Run compatibility checks and exit
  --update         Update system packages during startup
  --skip-update    Do not update system packages (default)
  --no-color       Disable colored output
  --version        Show version and exit
  -h, --help       Show help and exit
```

Examples:

```bash
# Display the installed script version
./autoinstaller.sh --version

# Check the server before opening the interactive menu
sudo ./autoinstaller.sh --check

# Open the menu without upgrading system packages
sudo ./autoinstaller.sh

# Upgrade packages first, then open the menu
sudo ./autoinstaller.sh --update

# Disable ANSI colors, useful for redirected output
sudo ./autoinstaller.sh --no-color
```

The standard `NO_COLOR` environment variable is also supported:

```bash
sudo NO_COLOR=1 ./autoinstaller.sh
```

## System Update Behavior

AutoInstaller no longer upgrades the entire operating system automatically on every startup. The default behavior is equivalent to `--skip-update`.

Use `--update` only when you intentionally want the script to:

* Refresh package indexes
* Upgrade installed packages
* Remove unused packages on APT-based systems
* Install required utilities such as `curl`, `wget`, `tar`, and `unzip`

This change prevents an unexpected system upgrade when the script is opened only for a management operation.

## Supported Operating Systems

| Operating System           | Description                           |
| -------------------------- | ------------------------------------- |
| CentOS / AlmaLinux / Rocky | Recommended for cPanel and CloudLinux |
| CloudLinux                 | CloudLinux-specific tools              |
| Debian 10+                 | Recommended for Plesk and aaPanel      |
| Ubuntu 20+                 | Recommended for Plesk and aaPanel      |

The script detects `apt`, `dnf`, or `yum` automatically. Individual control panels and plugins may have stricter vendor requirements; verify those requirements before installation.

## Features

### cPanel

* **Installation**

  * Install cPanel (official installer)

* **Server Tools**

  * Change Nameserver
  * Change Hostname
  * Change SSH Port (validation, backup, configuration test, and rollback)
  * Change Root Password

* **CSF Setup**

  * Install CSF
  * Configure CSF
  * Configure CSF Blocklists
  * Unblock Telegram IPs
  * Uninstall CSF

* **Plugins**

  * Install LiteSpeed
  * Install ImunifyAV
  * Install SSL (AutoSSL / Let's Encrypt)
  * Install WHMReseller (CentOS only)
  * Install WP Toolkit
  * Install PostgreSQL (CentOS only)
  * Install Softaculous
  * Install SitePad

* **CloudLinux Setup**

  * Install CloudLinux
  * Install CageFS
  * Install alt-php
  * Install ea-php (multiple versions)
  * Install mod-lsapi
  * Install Python
  * Install Ruby
  * Install NodeJS
  * Install MySQL Governor (not recommended)

* **FTP Server Setup**

  * Setup Pure-FTPd (recommended)
  * Setup ProFTPd
  * Disable FTP Services

* **Advanced Tools**

  * Restore Backup
  * Clear RAM Cache
  * Delete all error_log files
  * Clear /tmp

### Plesk

* **Installation**

  * Install Plesk (one-click installer)

* **Server Tools**

  * Change Nameserver
  * Change Hostname
  * Change SSH Port (validation, backup, configuration test, and rollback)
  * Change Root Password

* **CSF Setup**

  * Install CSF
  * Configure CSF
  * Configure CSF Blocklists
  * Unblock Telegram IPs
  * Uninstall CSF

* **Plugins**

  * Install LiteSpeed
  * Install ImunifyAV
  * Install Softaculous
  * Install SitePad

* **Advanced Tools**

  * Clear RAM Cache
  * Delete all error_log files
  * Clear /tmp

### aaPanel

* **Installation**

  * Install aaPanel (CentOS / Ubuntu / Debian)

* **Server Tools**

  * Change Nameserver
  * Change Hostname
  * Change SSH Port (validation, backup, configuration test, and rollback)
  * Change Root Password

* **Management**

  * Start aaPanel
  * Stop aaPanel
  * Restart aaPanel
  * Uninstall aaPanel
  * Change aaPanel Password
  * View Current Port
  * Change aaPanel Port
  * Turn off SSL for aaPanel
  * View Error Logs (panel and sites)

* **WebServer Setup**

  * Nginx

    * Start / Stop / Restart / Reload
    * Status
    * Configuration (nano / vi / vim)
    * Open Directory
  * Apache

    * Start / Stop / Restart / Reload
    * Status
    * Configuration (nano / vi / vim)
    * Open Directory

* **MySQL Setup**

  * Start / Stop / Restart / Reload
  * Status
  * Change Password
  * Configuration
  * Open Directories (mysql / phpmyadmin / data)

* **FTP Setup**

  * Start / Stop / Restart / Reload
  * Status
  * Configuration
  * Open Directory

* **Redis Setup**

  * Start / Stop / Restart
  * Status
  * Configuration
  * Open Directory

* **Memcached Setup**

  * Start / Stop / Restart
  * Status
  * Open Directory

## Improvements

Version 3.0.0 includes the following improvements while preserving all existing menu options:

* Added `--check`, `--update`, `--skip-update`, `--no-color`, `--version`, and `--help`
* Disabled automatic full-system upgrades by default
* Added centralized HTTPS downloads with retries, timeouts, and failure checks
* Replaced direct remote-script piping with temporary-file downloads and controlled execution
* Added IPv4 validation for nameserver changes
* Added hostname and TCP/UDP port-range validation
* Added SSH configuration testing and automatic rollback when validation or restart fails
* Added structured logging and command failure reporting
* Added signal handling for interrupted operations
* Added `pipefail` for more reliable pipeline error detection
* Initialized collected system information safely when some Linux utilities are unavailable
* Preserved manual backup filename entry while requiring an HTTPS backup URL
* Improved non-interactive output and `NO_COLOR` support
* Reduced duplicated code for better maintainability
* Improved menu handling and consistent behavior across supported operating systems

## Security and Safety

AutoInstaller performs privileged and potentially destructive server operations. Review each confirmation prompt carefully and keep a current server backup.

Version 3 applies these safeguards:

* Remote installer downloads must use HTTPS
* Downloads fail on HTTP errors and retry transient failures
* Backup restoration accepts HTTPS URLs only
* SSH configuration is backed up before editing
* `sshd -t` validates SSH configuration when available
* Failed SSH validation or restart restores the previous configuration
* Nameserver, hostname, menu, and port inputs are validated
* Destructive menu actions still require explicit confirmation

Third-party installers are maintained by their respective vendors. HTTPS protects the download in transit but does not replace reviewing vendor scripts and documentation.

## Logging and Troubleshooting

Runtime events and command failures are written by default to:

```text
/var/log/autoinstaller.log
```

Use a different log file with the `AUTOINSTALLER_LOG` environment variable:

```bash
sudo AUTOINSTALLER_LOG=/tmp/autoinstaller.log ./autoinstaller.sh --check
```

Recommended diagnostics:

```bash
# Validate Bash syntax
bash -n autoinstaller.sh

# Check OS detection and required commands
sudo ./autoinstaller.sh --check

# Review recent log entries
sudo tail -n 100 /var/log/autoinstaller.log
```

The `--check` command reports server information, detected package manager, logging path, and missing core tools without opening the interactive installer.

## Support & Contributions

If you encounter any issues or have suggestions for improvement, please use:

* [Github issues](https://github.com/DevURANIUM/AutoInstaller/issues)

Pull requests are welcome.

## Donation Links

Support the project through donations:

* **BTC**: `bc1qcclcp574hnznm0nmdzzf0ta7366svjskttqks3`
* **LTC**: `ltc1qcrkelw38gjrmg0ptjy2nshqej622kp76het7q0`
* **XRP**: `rPoK5SBChFPqEiQv1W97LW6FKoJZLipDVQ`
* **XLM**: `GDMUQREEZNBSTQOT5BV7MYEMXJFV3CYRZXUVOYCTIUZTHUWPHLVASFVD`
* **TON**: `UQAJH2N0pqpvC9YN841w5NH1dCN9Lakwkpjvoy7vXf-vfqgv`
* **TRON**: `TXJqhhwvkrTdnf5HReZf55hEzZuxjto3R4`
* **USDT(BEP20)**: `0x1591036c4bD05b046532B65Df939fcd7824E18c7`

---

Always test control-panel changes on a staging server or a fresh snapshot before using them in production.
