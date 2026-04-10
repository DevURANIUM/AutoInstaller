# AutoInstaller

**AutoInstaller** is a Bash-based automation script designed to install and manage popular web hosting control panels and common server services through a simple interactive menu.

It supports installation, configuration, and management of:

* cPanel
* Plesk
* aaPanel
* Server services (CSF, FTP, Web Server, Database, etc.)

## Table of Contents

* [Installation](#installation)
* [Supported Operating Systems](#supported-operating-systems)
* [Features](#features)

  * [cPanel](#cpanel)
  * [Plesk](#plesk)
  * [aaPanel](#aapanel)
* [Improvements](#improvements)
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

4. Run the script (as root):

   ```bash
   ./autoinstaller.sh
   ```

## Supported Operating Systems

| Operating System           | Description                           |
| -------------------------- | ------------------------------------- |
| CentOS / AlmaLinux / Rocky | Recommended for cPanel and CloudLinux |
| Debian 10+                 | Recommended for Plesk                 |
| Ubuntu 20+                 | Recommended for aaPanel               |

## Features

### cPanel

* **Installation**

  * Install cPanel (official installer)

* **Server Tools**

  * Change Nameserver
  * Change Hostname
  * Change SSH Port (with safer handling)
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
  * Change SSH Port
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
  * Change SSH Port
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

* Reduced duplicated code for better maintainability
* Improved menu handling and input validation
* Fixed logical issues in some sections (plugins, ports, menus)
* Safer handling of system configuration files
* More consistent behavior across different OS types

## Support & Contributions

If you encounter any issues or have suggestions for improvement, please use:

* [https://github.com/DevURANIUM/AutoInstaller/issues](https://github.com/DevURANIUM/AutoInstaller/issues)

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

Feel free to modify or expand upon this template as needed!
