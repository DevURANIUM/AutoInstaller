# AutoInstaller

**AutoInstaller** is a versatile script for automatically installing and configuring popular web hosting control panels (cPanel, Plesk, aaPanel) and various server components. This script is written in Bash.

## Table of Contents
- [Installation](#installation)
- [Supported Operating Systems](#supported-operating-systems)
- [Features](#features)
  - [cPanel](#cpanel)
  - [Plesk](#plesk)
  - [aaPanel](#aapanel)
- [Support & Contributions](#support--contributions)
- [Donation Links](#donation-links)

## Installation

To get started, follow these steps:

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

4. Run the script:
   ```bash
   ./autoinstaller.sh
   ```

## Supported Operating Systems

| Operating System | Description |
| ---------------- | ----------- |
| CentOS 7+        | Recommended for cPanel installation |
| Debian 10+       | Recommended for Plesk installation |
| Ubuntu 20+       | Recommended for aaPanel and cPanel installation |

## Features

### cPanel
- **Installation**
  - Install cPanel

- **Server Tools**
  - Change Nameserver
  - Change Hostname
  - Change SSH Port
  - Change Root Password

- **CSF Setup**
  - Configure CSF
  - Configure CSF Blocklists
  - Unblock Telegram IPs
  - Uninstall CSF

- **Plugins**
  - Install LiteSpeed
  - Install ImunifyAV
  - Install SSL
  - Install WHMReseller
  - Install WP Toolkit
  - Install PostgreSQL
  - Install Softaculous
  - Install SitePad

- **CloudLinux Setup**
  - Install CloudLinux
  - Install CageFS
  - Install alt-php
  - Install ea-php
  - Install mod-lsapi
  - Install Python
  - Install Ruby
  - Install NodeJS
  - Install MySQL Governor (not recommended)

- **FTP Server Setup**
  - Install Pure-FTPd (recommended)
  - Install ProFTP
  - Disable FTP Services

- **Advanced Tools**
  - Restore Backup
  - Clear RAM Cache
  - Delete all error_log
  - Clear /tmp

### Plesk
- **Installation**
  - Install Plesk

- **Server Tools**
  - Change Nameserver
  - Change Hostname
  - Change SSH Port
  - Change Root Password

- **CSF Setup**
  - Configure CSF
  - Configure CSF Blocklists
  - Unblock Telegram IPs
  - Uninstall CSF

- **Plugins**
  - Install LiteSpeed
  - Install ImunifyAV
  - Install Softaculous
  - Install SitePad

- **Advanced Tools**
  - Clear RAM Cache
  - Delete all error_log
  - Clear /tmp

### aaPanel
- **Installation**
  - Install aaPanel

- **Server Tools**
  - Change Nameserver
  - Change Hostname
  - Change SSH Port
  - Change Root Password

- **Management**
  - Start aaPanel
  - Stop aaPanel
  - Restart aaPanel
  - Uninstall aaPanel
  - Change aaPanel Password
  - View Current Port
  - Change aaPanel Port
  - Turn off SSL for aaPanel
  - View Error Logs for aaPanel
  - View Site Error Logs

- **WebServer Setup**
  - **Nginx**
    - Start Nginx
    - Stop Nginx
    - Restart Nginx
    - Reload Nginx
    - Check Nginx Status
    - Configure Nginx
    - Open Nginx Directory

  - **Apache**
    - Start Apache
    - Stop Apache
    - Restart Apache
    - Reload Apache
    - Check Apache Status
    - Configure Apache
    - Open Apache Directory

- **MySQL Setup**
  - Start MySQL
  - Stop MySQL
  - Restart MySQL
  - Reload MySQL
  - Check MySQL Status
  - Change MySQL Password
  - Configure MySQL
  - Open MySQL Directory
  - Open phpMyAdmin Directory
  - Open Data Storage Directory

- **FTP Setup**
  - Start FTP
  - Stop FTP
  - Restart FTP
  - Reload FTP
  - Check FTP Status
  - Configure FTP
  - Open FTP Directory

- **Redis Setup**
  - Start Redis
  - Stop Redis
  - Restart Redis
  - Check Redis Status
  - Configure Redis
  - Open Redis Directory

- **Memcached Setup**
  - Start Memcached
  - Stop Memcached
  - Restart Memcached
  - Check Memcached Status
  - Open Memcached Directory

## Support & Contributions

If you encounter any issues or have suggestions for improvement, please reach out via:

- [Telegram](https://t.me/DevURANIUM)
- [GitHub Issues](https://github.com/DevURANIUM/AutoInstaller/issues)

## Donation Links

Support the project through donations:

- **BTC**: `bc1qcclcp574hnznm0nmdzzf0ta7366svjskttqks3`
- **TRON**: `TXJqhhwvkrTdnf5HReZf55hEzZuxjto3R4`
- **USDT-(TRC20)**: `TXJqhhwvkrTdnf5HReZf55hEzZuxjto3R4`
- **TON**: `UQAJH2N0pqpvC9YN841w5NH1dCN9Lakwkpjvoy7vXf-vfqgv`

---

Feel free to modify or expand upon this template as needed!
