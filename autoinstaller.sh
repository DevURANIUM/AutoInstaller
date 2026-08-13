#!/usr/bin/env bash
#
# Refactored Auto Installer
# Original concept by M.A.H
# Email: info@heydari.org
# Refactor goal: keep features, improve structure, safety, maintainability

set -uo pipefail

readonly APP_NAME="Auto Installer"
readonly VERSION="3.0.0"
readonly LOG_FILE="${AUTOINSTALLER_LOG:-/var/log/autoinstaller.log}"

AUTO_UPDATE=0
CHECK_ONLY=0
NO_COLOR="${NO_COLOR:-}"

# -----------------------------
# Colors
# -----------------------------
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

if [[ -n "$NO_COLOR" || ! -t 1 ]]; then
  BLUE=''
  RED=''
  YELLOW=''
  GREEN=''
  NC=''
fi

print_b() { printf '%b\n' "${BLUE}$*${NC}"; }
print_r() { printf '%b\n' "${RED}$*${NC}" >&2; }
print_y() { printf '%b\n' "${YELLOW}$*${NC}"; }
print_g() { printf '%b\n' "${GREEN}$*${NC}"; }

# -----------------------------
# Banners
# -----------------------------
message='

    /$$$$$$              /$$                     /$$$$$$                       /$$               /$$ /$$
   /$$__  $$            | $$                    |_  $$_/                      | $$              | $$| $$
  | $$  \ $$ /$$   /$$ /$$$$$$    /$$$$$$         | $$   /$$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$ | $$| $$  /$$$$$$   /$$$$$$
  | $$$$$$$$| $$  | $$|_  $$_/   /$$__  $$        | $$  | $$__  $$ /$$_____/|_  $$_/   |____  $$| $$| $$ /$$__  $$ /$$__  $$
  | $$__  $$| $$  | $$  | $$    | $$  \ $$        | $$  | $$  \ $$|  $$$$$$   | $$      /$$$$$$$| $$| $$| $$$$$$$$| $$  \__/
  | $$  | $$| $$  | $$  | $$ /$$| $$  | $$        | $$  | $$  | $$ \____  $$  | $$ /$$ /$$__  $$| $$| $$| $$_____/| $$
  | $$  | $$|  $$$$$$/  |  $$$$/|  $$$$$$/       /$$$$$$| $$  | $$ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$| $$|  $$$$$$$| $$
  |__/  |__/ \______/    \___/   \______/       |______/|__/  |__/|_______/    \___/   \_______/|__/|__/ \_______/|__/
                                                                                                                        #DevURANIUM
                                                                                                                        @DevURANIUM
'

cPanel='
       ____                  _
   ___|  _ \ __ _ _ __   ___| |
  / __| |_) / _` | `_ \ / _ \ |
 | (__|  __/ (_| | | | |  __/ |
  \___|_|   \__,_|_| |_|\___|_|
'

Plesk='
  ____  _           _
 |  _ \| | ___  ___| | __
 | |_) | |/ _ \/ __| |/ /
 |  __/| |  __/\__ \   <
 |_|   |_|\___||___/_|\_\
'

aaPanel='
              ____                  _
   __ _  __ _|  _ \ __ _ _ __   ___| |
  / _` |/ _` | |_) / _` | `_ \ / _ \ |
 | (_| | (_| |  __/ (_| | | | |  __/ |
  \__,_|\__,_|_|   \__,_|_| |_|\___|_|
'

InstallcPanel='
  ___           _        _ _        ____                  _
 |_ _|_ __  ___| |_ __ _| | |   ___|  _ \ __ _  ___ _ __ | |
  | || `_ \/ __| __/ _` | | |  / __| |_) / _` |/ _ \ `_ \| |
  | || | | \__ \ || (_| | | | | (__|  __/ (_| |  __/ | | | |
 |___|_| |_|___/\__\__,_|_|_|  \___|_|   \__,_|\___|_| |_|_|
'

InstallPlesk='
  ___           _        _ _   ____  _           _
 |_ _|_ __  ___| |_ __ _| | | |  _ \| | ___  ___| | __
  | || `_ \/ __| __/ _` | | | | |_) | |/ _ \/ __| |/ /
  | || | | \__ \ || (_| | | | |  __/| |  __/\__ \   <
 |___|_| |_|___/\__\__,_|_|_| |_|   |_|\___||___/_|\_\
'

InstallaaPanel='
  ___           _        _ _               ____                  _
 |_ _|_ __  ___| |_ __ _| | |   __ _  __ _|  _ \ __ _ _ __   ___| |
  | || `_ \/ __| __/ _` | | |  / _` |/ _` | |_) / _` | `_ \ / _ \ |
  | || | | \__ \ || (_| | | | | (_| | (_| |  __/ (_| | | | |  __/ |
 |___|_| |_|___/\__\__,_|_|_|  \__,_|\__,_|_|   \__,_|_| |_|\___|_|
'

Tools='
  ____                             _____           _
 / ___|  ___ _ ____   _____ _ __  |_   _|__   ___ | |___
 \___ \ / _ \ `__\ \ / / _ \ `__|   | |/ _ \ / _ \| / __|
  ___) |  __/ |   \ V /  __/ |      | | (_) | (_) | \__ \
 |____/ \___|_|    \_/ \___|_|      |_|\___/ \___/|_|___/
'

CSF='
  ____       _                  ____ ____  _____
 / ___|  ___| |_ _   _ _ __    / ___/ ___||  ___|
 \___ \ / _ \ __| | | | `_ \  | |   \___ \| |_   
  ___) |  __/ |_| |_| | |_) | | |___ ___) |  _|  
 |____/ \___|\__|\__,_| .__/   \____|____/|_|    
                      |_|
'

Plugins='
  ___           _        _ _   ____  _             _
 |_ _|_ __  ___| |_ __ _| | | |  _ \| |_   _  __ _(_)_ __  ___
  | || `_ \/ __| __/ _` | | | | |_) | | | | |/ _` | | `_ \/ __|
  | || | | \__ \ || (_| | | | |  __/| | |_| | (_| | | | | \__ \
 |___|_| |_|___/\__\__,_|_|_| |_|   |_|\__,_|\__, |_|_| |_|___/
                                             |___/
'

CloudLinux='
  ____       _                  ____ _                 _ _     _
 / ___|  ___| |_ _   _ _ __    / ___| | ___  _   _  __| | |   (_)_ __  _   ___  __
 \___ \ / _ \ __| | | | `_ \  | |   | |/ _ \| | | |/ _` | |   | | `_ \| | | \ \/ /
  ___) |  __/ |_| |_| | |_) | | |___| | (_) | |_| | (_| | |___| | | | | |_| |>  <
 |____/ \___|\__|\__,_| .__/   \____|_|\___/ \__,_|\__,_|_____|_|_| |_|\__,_/_/\_\\
                      |_|
'

Advanced='
     _       _                               _   _____           _
    / \   __| |_   ____ _ _ __   ___ ___  __| | |_   _|__   ___ | |___
   / _ \ / _` \ \ / / _` | `_ \ / __/ _ \/ _` |   | |/ _ \ / _ \| / __|
  / ___ \ (_| |\ V / (_| | | | | (_|  __/ (_| |   | | (_) | (_) | \__ \
 /_/   \_\__,_| \_/ \__,_|_| |_|\___\___|\__,_|   |_|\___/ \___/|_|___/
'

FTP='
  ____       _                 _____ _____ ____    ____
 / ___|  ___| |_ _   _ _ __   |  ___|_   _|  _ \  / ___|  ___ _ ____   _____ _ __
 \___ \ / _ \ __| | | | `_ \  | |_    | | | |_) | \___ \ / _ \ `__\ \ / / _ \ `__|
  ___) |  __/ |_| |_| | |_) | |  _|   | | |  __/   ___) |  __/ |   \ V /  __/ |
 |____/ \___|\__|\__,_| .__/  |_|     |_| |_|     |____/ \___|_|    \_/ \___|_|
                      |_|
'

Management='
  ____       _                 __  __                                                   _
 / ___|  ___| |_ _   _ _ __   |  \/  | __ _ _ __   __ _  __ _  ___ _ __ ___   ___ _ __ | |_
 \___ \ / _ \ __| | | | `_ \  | |\/| |/ _` | `_ \ / _` |/ _` |/ _ \ `_ ` _ \ / _ \ `_ \| __|
  ___) |  __/ |_| |_| | |_) | | |  | | (_| | | | | (_| | (_| |  __/ | | | | |  __/ | | | |_
 |____/ \___|\__|\__,_| .__/  |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_| |_| |_|\___|_| |_|\__|
                      |_|                               |___/
'

WebServer='
 __        __   _    ____
 \ \      / /__| |__/ ___|  ___ _ ____   _____ _ __
  \ \ /\ / / _ \ `_ \___ \ / _ \ `__\ \ / / _ \ `__|
   \ V  V /  __/ |_) |__) |  __/ |   \ V /  __/ |
    \_/\_/ \___|_.__/____/ \___|_|    \_/ \___|_|
'

Mysql='
  ____       _                 __  __                 _
 / ___|  ___| |_ _   _ _ __   |  \/  |_   _ ___  __ _| |
 \___ \ / _ \ __| | | | `_ \  | |\/| | | | / __|/ _` | |
  ___) |  __/ |_| |_| | |_) | | |  | | |_| \__ \ (_| | |
 |____/ \___|\__|\__,_| .__/  |_|  |_|\__, |___/\__, |_|
                      |_|             |___/        |_|
'

Redis='
  ____       _                 ____          _ _
 / ___|  ___| |_ _   _ _ __   |  _ \ ___  __| (_)___
 \___ \ / _ \ __| | | | `_ \  | |_) / _ \/ _` | / __|
  ___) |  __/ |_| |_| | |_) | |  _ <  __/ (_| | \__ \
 |____/ \___|\__|\__,_| .__/  |_| \_\___|\__,_|_|___/
                      |_|
'

Memcached='
  ____       _                 __  __                               _              _
 / ___|  ___| |_ _   _ _ __   |  \/  | ___ _ __ ___   ___ __ _  ___| |__   ___  __| |
 \___ \ / _ \ __| | | | `_ \  | |\/| |/ _ \ `_ ` _ \ / __/ _` |/ __| `_ \ / _ \/ _` |
  ___) |  __/ |_| |_| | |_) | | |  | |  __/ | | | | | (_| (_| | (__| | | |  __/ (_| |
 |____/ \___|\__|\__,_| .__/  |_|  |_|\___|_| |_| |_|\___\__,_|\___|_| |_|\___|\__,_|
                      |_|
'

# -----------------------------
# Global state
# -----------------------------
OS_ID="unknown"
OS_LIKE=""
PKG_MANAGER=""
SSH_SERVICE="sshd"
APACHE_SERVICE="apache2"
MYSQL_SERVICE="mysql"
IP_ADDRESS=""
INPUT=""
HOSTNAME_VALUE="unknown"
VIRTUALIZATION="unknown"
OPERATING_SYSTEM="unknown"
KERNEL="unknown"
ARCHITECTURE="unknown"
VENDOR="unknown"
MODEL="unknown"
CPU_NAME="unknown"
CPU_CORES="unknown"
MEM_TOTAL="unknown"
HDD_TOTAL="unknown"

# -----------------------------
# Helpers
# -----------------------------
require_root() {
  if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    print_r "Please run this script as root."
    exit 1
  fi
}

pause_screen() {
  read -r -p "Press Enter to continue..." _
}

clear_screen() {
  clear 2>/dev/null || true
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

log_message() {
  local level="$1"
  shift
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*" >> "$LOG_FILE" 2>/dev/null || true
}

die() {
  print_r "Error: $*"
  log_message ERROR "$*"
  return 1
}

on_error() {
  local status="$1" line="$2"
  log_message ERROR "Command failed with status $status at line $line"
}

trap 'on_error "$?" "$LINENO"' ERR
trap 'printf "\n"; print_y "Operation interrupted."; exit 130' INT TERM

run_command() {
  local description="$1"
  shift
  print_y "$description..."
  log_message INFO "$description"
  if "$@"; then
    print_g "$description completed."
    return 0
  fi
  die "$description failed. See $LOG_FILE for details."
}

download_file() {
  local url="$1" destination="$2"
  [[ "$url" == https://* ]] || { die "Refusing insecure download URL: $url"; return 1; }

  if command_exists curl; then
    curl --fail --location --show-error --silent --retry 3 --connect-timeout 20 \
      --output "$destination" "$url"
  elif command_exists wget; then
    wget --https-only --tries=3 --timeout=30 --output-document="$destination" "$url"
  else
    die "curl or wget is required to download files."
  fi
}

run_downloaded_script() {
  local url="$1"
  shift
  local temporary_script
  temporary_script=$(mktemp "${TMPDIR:-/tmp}/autoinstaller.XXXXXX") || return 1
  if download_file "$url" "$temporary_script"; then
    chmod 700 "$temporary_script"
    bash "$temporary_script" "$@"
    local status=$?
    rm -f "$temporary_script"
    return "$status"
  fi
  rm -f "$temporary_script"
  return 1
}

validate_port() {
  [[ "$1" =~ ^[0-9]+$ ]] && (( 10#$1 >= 1 && 10#$1 <= 65535 ))
}

validate_hostname() {
  [[ ${#1} -le 253 && "$1" =~ ^[A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?$ && "$1" != *..* ]]
}

validate_ip_address() {
  local ip="$1" part
  local -a parts
  IFS=. read -r -a parts <<< "$ip"
  (( ${#parts[@]} == 4 )) || return 1
  for part in "${parts[@]}"; do
    [[ "$part" =~ ^[0-9]{1,3}$ ]] && (( 10#$part <= 255 )) || return 1
  done
}

service_restart_any() {
  local svc="$1"
  systemctl restart "$svc" 2>/dev/null || service "$svc" restart 2>/dev/null
}

service_action() {
  local svc="$1"
  local action="$2"
  systemctl "$action" "$svc" 2>/dev/null || service "$svc" "$action" 2>/dev/null
}

is_yes() {
  [[ "$1" == "y" ]]
}

validate_yn_input() {
  local prompt="$1"
  while true; do
    read -r -p "$prompt " INPUT
    INPUT=$(printf '%s' "$INPUT" | tr '[:upper:]' '[:lower:]')
    case "$INPUT" in
      y|n) return 0 ;;
      *) print_r "Invalid input. Please enter y or n." ;;
    esac
  done
}

confirm_or_return() {
  local prompt="$1"
  validate_yn_input "$prompt"
  is_yes "$INPUT"
}

validate_menu_input() {
  local prompt="$1"
  local min="$2"
  local max="$3"

  while true; do
    read -r -p "$prompt" INPUT
    if [[ "$INPUT" =~ ^[0-9]+$ ]] && (( INPUT >= min && INPUT <= max )); then
      return 0
    fi
    print_r "Invalid input. Please enter a number between $min and $max"
  done
}

safe_read() {
  local var_name="$1"
  local prompt="$2"
  read -r -p "$prompt" "$var_name"
}

replace_or_append_key_value() {
  local file="$1"
  local key="$2"
  local value="$3"

  [[ -f "$file" ]] || return 1

  if grep -qE "^${key}=" "$file"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$file"
  else
    echo "${key}=${value}" >> "$file"
  fi
}

load_os_info() {
  if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    OS_ID="${ID:-unknown}"
    OS_LIKE="${ID_LIKE:-}"
  fi

  if command_exists apt; then
    PKG_MANAGER="apt"
    SSH_SERVICE="ssh"
    APACHE_SERVICE="apache2"
    MYSQL_SERVICE="mysql"
  elif command_exists dnf; then
    PKG_MANAGER="dnf"
    SSH_SERVICE="sshd"
    APACHE_SERVICE="httpd"
    MYSQL_SERVICE="mysqld"
  elif command_exists yum; then
    PKG_MANAGER="yum"
    SSH_SERVICE="sshd"
    APACHE_SERVICE="httpd"
    MYSQL_SERVICE="mysqld"
  else
    PKG_MANAGER="unknown"
  fi
}

update_system_packages() {
  if (( AUTO_UPDATE == 0 )); then
    print_y "Automatic system upgrade is disabled. Use --update to enable it."
    return 0
  fi

  case "$PKG_MANAGER" in
    yum)
      yum update -y
      for pkg in perl wget curl screen tar unzip; do
        rpm -q "$pkg" >/dev/null 2>&1 || yum install -y "$pkg"
      done
      ;;
    dnf)
      dnf update -y
      for pkg in perl wget curl screen tar unzip; do
        rpm -q "$pkg" >/dev/null 2>&1 || dnf install -y "$pkg"
      done
      ;;
    apt)
      apt update
      apt upgrade -y
      apt autoremove -y
      for pkg in perl wget curl screen tar unzip; do
        dpkg -s "$pkg" >/dev/null 2>&1 || apt install -y "$pkg"
      done
      ;;
    *)
      print_r "Unsupported package manager. Skipping package bootstrap."
      ;;
  esac
}

system_check() {
  local failures=0 tool
  print_b "$APP_NAME $VERSION - system check"
  information
  echo
  print_y "Required tools:"
  for tool in bash awk sed grep tar; do
    if command_exists "$tool"; then
      print_g "  [OK] $tool"
    else
      print_r "  [MISSING] $tool"
      failures=$((failures + 1))
    fi
  done
  if command_exists curl || command_exists wget; then
    print_g "  [OK] downloader"
  else
    print_r "  [MISSING] curl/wget"
    failures=$((failures + 1))
  fi
  print_y "Package manager: $PKG_MANAGER"
  print_y "Log file: $LOG_FILE"
  (( failures == 0 ))
}

collect_server_info() {
  local output hostnamectl_available
  hostnamectl_available=0

  if command_exists hostnamectl; then
    hostnamectl_available=1
    output=$(hostnamectl 2>/dev/null || true)
  else
    output=""
  fi

  HOSTNAME_VALUE=$(hostname 2>/dev/null || echo "unknown")
  VIRTUALIZATION=$(echo "$output" | awk -F': ' '/Virtualization:/ {print $2}')
  OPERATING_SYSTEM=$(echo "$output" | awk -F': ' '/Operating System:/ {print $2}')
  KERNEL=$(uname -r 2>/dev/null || echo "unknown")
  ARCHITECTURE=$(uname -m 2>/dev/null || echo "unknown")
  VENDOR=$(echo "$output" | awk -F': ' '/Hardware Vendor:/ {print $2}')
  MODEL=$(echo "$output" | awk -F': ' '/Hardware Model:/ {print $2}')
  CPU_NAME=$(awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo 2>/dev/null)
  CPU_CORES=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null || echo "unknown")
  MEM_TOTAL=$(free -h 2>/dev/null | awk '/^Mem:/ {print $2}')
  HDD_TOTAL=$(df -h --total 2>/dev/null | awk 'END {print $2}')
  IP_ADDRESS=$(hostname -I 2>/dev/null | awk '{print $1}')

  [[ -n "$OPERATING_SYSTEM" ]] || OPERATING_SYSTEM="${PRETTY_NAME:-$OS_ID}"
  [[ -n "$VIRTUALIZATION" ]] || VIRTUALIZATION="unknown"
  [[ -n "$VENDOR" ]] || VENDOR="unknown"
  [[ -n "$MODEL" ]] || MODEL="unknown"
  [[ -n "$CPU_NAME" ]] || CPU_NAME="unknown"
  [[ -n "$MEM_TOTAL" ]] || MEM_TOTAL="unknown"
  [[ -n "$HDD_TOTAL" ]] || HDD_TOTAL="unknown"
  [[ -n "$IP_ADDRESS" ]] || IP_ADDRESS="unknown"
}

information() {
  echo -e "\033[33m  Static Hostname\033[0m : \033[34m${HOSTNAME_VALUE}\033[0m"
  echo -e "\033[33m  Virtualization\033[0m : \033[34m${VIRTUALIZATION}\033[0m"
  echo -e "\033[33m  Operating System\033[0m : \033[34m${OPERATING_SYSTEM}\033[0m"
  echo -e "\033[33m  Kernel\033[0m : \033[34m${KERNEL}\033[0m"
  echo -e "\033[33m  Architecture\033[0m : \033[34m${ARCHITECTURE}\033[0m"
  echo -e "\033[33m  Hardware Vendor\033[0m : \033[34m${VENDOR}\033[0m"
  echo -e "\033[33m  Hardware Model\033[0m : \033[34m${MODEL}\033[0m"
  echo -e "\033[33m  CPU\033[0m : \033[34m${CPU_NAME} (${CPU_CORES} Cores)\033[0m"
  echo -e "\033[33m  Memory\033[0m : \033[34m${MEM_TOTAL}\033[0m"
  echo -e "\033[33m  Hard Disk\033[0m : \033[34m${HDD_TOTAL}\033[0m"
  echo -e "\033[33m  IP Address\033[0m : \033[34m${IP_ADDRESS}\033[0m"
}

is_centos_family() {
  [[ "$OS_ID" == "centos" || "$OS_ID" == "rhel" || "$OS_ID" == "almalinux" || "$OS_ID" == "rocky" || "$OS_LIKE" == *"rhel"* ]]
}

is_ubuntu_family() {
  [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" || "$OS_LIKE" == *"debian"* ]]
}

is_cloudlinux() {
  [[ "$OS_ID" == "cloudlinux" || "$OS_LIKE" == *"cloudlinux"* ]]
}

# -----------------------------
# Common Server Tools
# -----------------------------
change_nameserver() {
  confirm_or_return "Are you sure you want to change the Nameserver? (y/n):" || return 0

  local primary_ns secondary_ns backup_file
  safe_read primary_ns "Enter Primary Nameserver: "
  safe_read secondary_ns "Enter Secondary Nameserver: "

  if ! validate_ip_address "$primary_ns" || ! validate_ip_address "$secondary_ns"; then
    print_r "Invalid IPv4 nameserver address."
    pause_screen
    return 1
  fi

  if [[ -f /etc/resolv.conf ]]; then
    backup_file="/etc/resolv.conf.bak.$(date +%Y%m%d%H%M%S)"
    cp -f /etc/resolv.conf "$backup_file"
    {
      echo "nameserver $primary_ns"
      echo "nameserver $secondary_ns"
    } > /etc/resolv.conf
    print_b "Nameserver changed to -> [ $primary_ns - $secondary_ns ]"
    print_g "Backup saved at: $backup_file"
  else
    print_r "/etc/resolv.conf not found."
  fi
  pause_screen
}

change_hostname() {
  confirm_or_return "Are you sure you want to change the Hostname? (y/n):" || return 0

  local new_hostname
  safe_read new_hostname "Enter your Hostname: "
  if validate_hostname "$new_hostname"; then
    hostnamectl set-hostname "$new_hostname"
    print_b "Hostname changed to -> $new_hostname"
  else
    print_r "Invalid hostname. Use letters, numbers, dots and hyphens only."
  fi
  pause_screen
}

change_ssh_port() {
  confirm_or_return "Are you sure you want to change SSH Port? (y/n):" || return 0

  local new_port ssh_config backup_file
  safe_read new_port "Enter new SSH port: "

  if ! validate_port "$new_port"; then
    print_r "Invalid port number."
    pause_screen
    return 1
  fi

  ssh_config="/etc/ssh/sshd_config"
  if [[ ! -f "$ssh_config" ]]; then
    print_r "$ssh_config not found."
    pause_screen
    return 1
  fi

  backup_file="${ssh_config}.bak.$(date +%Y%m%d%H%M%S)"
  cp -f "$ssh_config" "$backup_file"

  if grep -qE '^#?Port ' "$ssh_config"; then
    sed -i "s/^#\?Port .*/Port $new_port/" "$ssh_config"
  else
    echo "Port $new_port" >> "$ssh_config"
  fi

  if command_exists sshd && ! sshd -t; then
    cp -f "$backup_file" "$ssh_config"
    print_r "SSH configuration test failed; the original file was restored."
    pause_screen
    return 1
  fi

  service_restart_any "$SSH_SERVICE" || {
    cp -f "$backup_file" "$ssh_config"
    service_restart_any "$SSH_SERVICE" || true
    print_r "SSH restart failed; the original configuration was restored."
    pause_screen
    return 1
  }
  print_b "SSH Port changed to -> $new_port"
  print_g "Backup saved at: $backup_file"
  pause_screen
}

change_root_password() {
  confirm_or_return "Are you sure you want to change root password? (y/n):" || return 0

  if [[ "$(whoami)" == "root" ]]; then
    passwd root
  else
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    service_restart_any "$SSH_SERVICE"
    passwd
  fi

  print_b "Password changed successfully."
  pause_screen
}

server_tools_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${Tools}\033[0m"
    print_y "What do you want to do?"
    print_g "1) Change Nameserver"
    print_g "2) Change Hostname"
    print_g "3) Change SSH Port"
    print_g "4) Change Password (root)"
    print_g "5) Back to Menu"
    validate_menu_input "Enter your choice (1-5): " 1 5

    case "$INPUT" in
      1) clear_screen; change_nameserver ;;
      2) clear_screen; change_hostname ;;
      3) clear_screen; change_ssh_port ;;
      4) clear_screen; change_root_password ;;
      5) clear_screen; break ;;
    esac
  done
}

# -----------------------------
# CSF
# -----------------------------
install_csf() {
  confirm_or_return "Are you sure you want to install CSF? (y/n):" || return 0
  cd /usr/src || return 1
  rm -f csf.tgz
  download_file https://download.configserver.com/csf.tgz csf.tgz || return 1
  tar -xzf csf.tgz
  cd csf || return 1
  sh install.sh
  perl /usr/local/csf/bin/csftest.pl
  print_g "ConfigServer Security & Firewall (CSF) successfully installed."
  pause_screen
}

configure_csf() {
  confirm_or_return "Are you sure you want to configure CSF? (y/n):" || return 0

  local conf="/etc/csf/csf.conf"
  [[ -f "$conf" ]] || { print_r "$conf not found."; pause_screen; return 1; }

  replace_or_append_key_value "$conf" TESTING '"0"'
  replace_or_append_key_value "$conf" CT_LIMIT '"100"'
  replace_or_append_key_value "$conf" CT_INTERVAL '"30"'
  replace_or_append_key_value "$conf" CT_EMAIL_ALERT '"1"'
  replace_or_append_key_value "$conf" CT_PORTS '"80,443,2083,2082,2087,20,21,25,110,113,123,465,993,995,22"'
  replace_or_append_key_value "$conf" CT_BLOCK_TIME '"3600"'
  replace_or_append_key_value "$conf" CT_PERMANENT '"1"'
  replace_or_append_key_value "$conf" CONNLIMIT '"22;5,443;20,80;20,20;20,21;20,25;20,110;20,113;20,123;20,465;20,993;20,995;20,2083;20,2082;20"'
  replace_or_append_key_value "$conf" RESTRICT_SYSLOG '"3"'
  replace_or_append_key_value "$conf" DENY_IP_LIMIT '"200"'
  replace_or_append_key_value "$conf" PACKET_FILTER '"1"'
  replace_or_append_key_value "$conf" PORTFLOOD '"1"'

  print_b "CSF configuration updated successfully."
  pause_screen
}

configure_csf_blocklists() {
  confirm_or_return "Are you sure you want to configure CSF blocklists? (y/n):" || return 0

  local file="/etc/csf/csf.blocklists"
  [[ -f "$file" ]] || { print_r "$file not found."; pause_screen; return 1; }

  print_y "Existing active blocklists:"
  grep -vE '^\s*#|^\s*$' "$file" || true
  print_b "CSF blocklists reviewed successfully."
  pause_screen
}

unblock_telegram_ips() {
  confirm_or_return "Are you sure you want to unblock Telegram IPs? (y/n):" || return 0

  local ip
  for ip in \
    149.154.168.0/22 \
    149.154.164.0/22 \
    149.154.172.0/22 \
    149.154.160.0/22 \
    91.108.4.0/22 \
    91.108.56.0/22 \
    91.108.16.0/22 \
    91.108.12.0/22 \
    91.108.8.0/22; do
    csf -a "$ip" "Telegram"
  done

  print_b "Telegram IPs unblocked successfully."
  pause_screen
}

uninstall_csf() {
  confirm_or_return "Are you sure you want to uninstall CSF? (y/n):" || return 0
  cd /etc/csf || return 1
  sh uninstall.sh
  print_b "CSF uninstalled successfully."
  pause_screen
}

csf_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${CSF}\033[0m"
    print_g "1) Install CSF"
    print_g "2) CSF Configuration"
    print_g "3) CSF Blocklists Configuration"
    print_g "4) Unblock Telegram IPs"
    print_g "5) Uninstall CSF"
    print_g "6) Back to Menu"
    validate_menu_input "Enter your choice (1-6): " 1 6

    case "$INPUT" in
      1) clear_screen; install_csf ;;
      2) clear_screen; configure_csf ;;
      3) clear_screen; configure_csf_blocklists ;;
      4) clear_screen; unblock_telegram_ips ;;
      5) clear_screen; uninstall_csf ;;
      6) clear_screen; break ;;
    esac
  done
}

# -----------------------------
# cPanel Plugins
# -----------------------------
install_litespeed_cpanel() {
  confirm_or_return "Are you sure you want to install LiteSpeed? (y/n):" || return 0
  cd /usr/src || return 1
  download_file https://www.litespeedtech.com/packages/cpanel/lsws_whm_plugin_install.sh lsws_whm_plugin_install.sh || return 1
  chmod 700 lsws_whm_plugin_install.sh
  ./lsws_whm_plugin_install.sh
  rm -f lsws_whm_plugin_install.sh
  print_b "LiteSpeed installed successfully."
  pause_screen
}

install_imunifyav() {
  confirm_or_return "Are you sure you want to install ImunifyAV? (y/n):" || return 0
  download_file https://repo.imunify360.cloudlinux.com/defence360/imav-deploy.sh /root/imav-deploy.sh || return 1
  bash /root/imav-deploy.sh
  rm -f /root/imav-deploy.sh
  print_b "ImunifyAV installed successfully."
  pause_screen
}

install_ssl_cpanel() {
  confirm_or_return "Are you sure you want to install SSL? (y/n):" || return 0
  /usr/local/cpanel/bin/checkallsslcerts
  /scripts/install_lets_encrypt_autossl_provider
  print_b "Let's Encrypt AutoSSL installed successfully."
  pause_screen
}

install_whmreseller() {
  confirm_or_return "Are you sure you want to install WHMReseller? (y/n):" || return 0

  if is_centos_family; then
    case "$PKG_MANAGER" in
      yum) yum install gcc-c++ -y ;;
      dnf) dnf install gcc-c++ -y ;;
      *) print_r "Unsupported package manager for WHMReseller."; pause_screen; return 1 ;;
    esac

    cd /usr/local/cpanel/whostmgr/docroot/cgi || return 1
    download_file https://deasoft.com/install.cpp install.cpp || return 1
    g++ install.cpp -o install
    chmod 700 install
    ./install
    print_b "WHMReseller installed successfully."
  else
    print_r "WHMReseller installation is only supported on CentOS-like systems."
  fi
  pause_screen
}

install_wp_toolkit_cpanel() {
  confirm_or_return "Are you sure you want to install WP Toolkit? (y/n):" || return 0
  run_downloaded_script https://wp-toolkit.plesk.com/cPanel/installer.sh || return 1
  print_b "WP Toolkit installed successfully."
  pause_screen
}

install_postgresql_cpanel() {
  confirm_or_return "Are you sure you want to install PostgreSQL? (y/n):" || return 0

  if is_centos_family; then
    case "$PKG_MANAGER" in
      yum) yum install postgresql-server -y ;;
      dnf) dnf install postgresql-server -y ;;
      *) print_r "Unsupported package manager for PostgreSQL."; pause_screen; return 1 ;;
    esac
    systemctl enable postgresql.service
    systemctl start postgresql.service
    /usr/local/cpanel/scripts/installpostgres
    print_b "PostgreSQL installed successfully."
  else
    print_r "PostgreSQL installation is only supported on CentOS-like systems."
  fi
  pause_screen
}

install_softaculous() {
  confirm_or_return "Are you sure ionCube is installed and active on your server? (y/n):" || return 0

  if php -m 2>/dev/null | grep -qi ionCube; then
    download_file https://files.softaculous.com/install.sh install.sh || return 1
    chmod 755 install.sh
    ./install.sh
    print_b "Softaculous installed successfully."
  else
    print_r "Error: ionCube is not installed on your server."
  fi
  pause_screen
}

install_sitepad() {
  confirm_or_return "Are you sure ionCube is installed and active on your server? (y/n):" || return 0

  if php -m 2>/dev/null | grep -qi ionCube; then
    cd /usr/local/src || return 1
    rm -f install.sh
    download_file https://files.sitepad.com/install.sh install.sh || return 1
    chmod +x install.sh
    ./install.sh
    print_b "SitePad installed successfully."
  else
    print_r "Error: ionCube is not installed on your server."
  fi
  pause_screen
}

cpanel_plugins_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${Plugins}\033[0m"
    print_g "1) Install LiteSpeed"
    print_g "2) Install ImunifyAV"
    print_g "3) Install SSL"
    print_g "4) Install WHMReseller"
    print_g "5) Install WP Toolkit"
    print_g "6) Install PostgreSQL"
    print_g "7) Install Softaculous"
    print_g "8) Install SitePad"
    print_g "9) Back to Menu"
    validate_menu_input "Enter your choice (1-9): " 1 9

    case "$INPUT" in
      1) clear_screen; install_litespeed_cpanel ;;
      2) clear_screen; install_imunifyav ;;
      3) clear_screen; install_ssl_cpanel ;;
      4) clear_screen; install_whmreseller ;;
      5) clear_screen; install_wp_toolkit_cpanel ;;
      6) clear_screen; install_postgresql_cpanel ;;
      7) clear_screen; install_softaculous ;;
      8) clear_screen; install_sitepad ;;
      9) clear_screen; break ;;
    esac
  done
}

# -----------------------------
# CloudLinux
# -----------------------------
install_cloudlinux() {
  confirm_or_return "Are you sure you want to install CloudLinux? (y/n):" || return 0

  if is_centos_family; then
    download_file https://repo.cloudlinux.com/cloudlinux/sources/cln/cldeploy cldeploy.sh || return 1
    print_g "Get a 30-day CloudLinux License: https://www.cloudlinux.com/trial"
    validate_yn_input "Do you use the free 30-day license? (y/n):"
    if is_yes "$INPUT"; then
      local license
      safe_read license "Enter your License: "
      sh cldeploy.sh -k "$license"
      print_b "CloudLinux installed successfully. Please reboot your system."
    else
      print_g "Use your own installation and activation command."
    fi
  else
    print_r "CloudLinux installation is only supported on CentOS-like systems."
  fi
  pause_screen
}

install_cagefs() {
  confirm_or_return "Are you sure you want to install CageFS? (y/n):" || return 0
  if is_cloudlinux; then
    case "$PKG_MANAGER" in
      yum) yum install cagefs -y ;;
      dnf) dnf install cagefs -y ;;
      *) print_r "Unsupported package manager."; pause_screen; return 1 ;;
    esac
    /usr/sbin/cagefsctl --init
    /usr/sbin/cagefsctl --enable-all
    print_b "CageFS installed successfully."
  else
    print_r "CageFS installation is only supported on CloudLinux."
  fi
  pause_screen
}

install_alt_php() {
  confirm_or_return "Are you sure you want to install alt-php? (y/n):" || return 0
  if is_cloudlinux; then
    case "$PKG_MANAGER" in
      yum) yum groupinstall alt-php -y; yum update cagefs lvemanager -y; yum groupupdate alt-php -y ;;
      dnf) dnf groupinstall alt-php -y; dnf update cagefs lvemanager -y; dnf groupupdate alt-php -y ;;
      *) print_r "Unsupported package manager."; pause_screen; return 1 ;;
    esac
    print_b "alt-php installed successfully."
  else
    print_r "alt-php installation is only supported on CloudLinux."
  fi
  pause_screen
}

install_ea_php() {
  confirm_or_return "Are you sure you want to install ea-php? (y/n):" || return 0
  if is_cloudlinux; then
    local php_versions=(ea-php82 ea-php81 ea-php80 ea-php74 ea-php73 ea-php72 ea-php71 ea-php70 ea-php56 ea-php55 ea-php54 ea-php53 ea-php52 ea-php51)
    local php
    for php in "${php_versions[@]}"; do
      case "$PKG_MANAGER" in
        yum) yum install -y "$php" ;;
        dnf) dnf install -y "$php" ;;
      esac
    done
    case "$PKG_MANAGER" in
      yum) yum update -y cagefs lvemanager ;;
      dnf) dnf update -y cagefs lvemanager ;;
    esac
    print_b "ea-php installed successfully."
  else
    print_r "ea-php installation is only supported on CloudLinux."
  fi
  pause_screen
}

install_mod_lsapi() {
  confirm_or_return "Are you sure you want to install mod-lsapi? (y/n):" || return 0
  if is_cloudlinux; then
    case "$PKG_MANAGER" in
      yum)
        yum install -y liblsapi liblsapi-devel ea-apache24-mod_lsapi
        ;;
      dnf)
        dnf install -y liblsapi liblsapi-devel ea-apache24-mod_lsapi
        ;;
    esac
    /usr/bin/switch_mod_lsapi --setup
    service_action "$APACHE_SERVICE" restart
    print_b "mod-lsapi installed successfully."
  else
    print_r "mod-lsapi installation is only supported on CloudLinux."
  fi
  pause_screen
}

install_cloudlinux_python() {
  confirm_or_return "Are you sure you want to install Python? (y/n):" || return 0
  if is_cloudlinux; then
    case "$PKG_MANAGER" in
      yum)
        yum -y groupinstall "Development Tools"
        yum -y install openssl-devel bzip2-devel libffi-devel
        yum groupinstall alt-python -y
        yum install -y lvemanager lve-utils alt-python-virtualenv alt-mod-passenger alt-python27-devel
        ;;
      dnf)
        dnf -y groupinstall "Development Tools"
        dnf -y install openssl-devel bzip2-devel libffi-devel
        dnf groupinstall alt-python -y
        dnf install -y lvemanager lve-utils alt-python-virtualenv alt-mod-passenger alt-python27-devel
        ;;
    esac
    print_b "Python installed successfully."
  else
    print_r "Python installation is only supported on CloudLinux."
  fi
  pause_screen
}

install_cloudlinux_ruby() {
  confirm_or_return "Are you sure you want to install Ruby? (y/n):" || return 0
  if is_cloudlinux; then
    case "$PKG_MANAGER" in
      yum)
        yum groupinstall alt-ruby -y
        yum install -y lvemanager alt-python-virtualenv ea-ruby24-mod_passenger
        ;;
      dnf)
        dnf groupinstall alt-ruby -y
        dnf install -y lvemanager alt-python-virtualenv ea-ruby24-mod_passenger
        ;;
    esac
    print_b "Ruby installed successfully."
  else
    print_r "Ruby installation is only supported on CloudLinux."
  fi
  pause_screen
}

install_cloudlinux_nodejs() {
  confirm_or_return "Are you sure you want to install NodeJS? (y/n):" || return 0
  if is_cloudlinux; then
    case "$PKG_MANAGER" in
      yum)
        yum groupinstall alt-nodejs -y
        yum install -y lvemanager lve-utils alt-mod-passenger
        ;;
      dnf)
        dnf groupinstall alt-nodejs -y
        dnf install -y lvemanager lve-utils alt-mod-passenger
        ;;
    esac
    print_b "NodeJS installed successfully."
  else
    print_r "NodeJS installation is only supported on CloudLinux."
  fi
  pause_screen
}

install_mysql_governor() {
  confirm_or_return "Are you sure you want to install MySQL Governor? (y/n):" || return 0
  if is_cloudlinux; then
    case "$PKG_MANAGER" in
      yum)
        yum remove -y db-governor db-governor-mysql || true
        yum install -y governor-mysql
        ;;
      dnf)
        dnf remove -y db-governor db-governor-mysql || true
        dnf install -y governor-mysql
        ;;
    esac
    local mysql_version
    safe_read mysql_version "Enter MySQL Version: "
    /usr/share/lve/dbgovernor/mysqlgovernor.py --mysql-version="$mysql_version"
    /usr/share/lve/dbgovernor/mysqlgovernor.py --install --yes
    /usr/share/lve/dbgovernor/mysqlgovernor.py --dbupdate
    service_action db_governor restart
    service_action db_governor start
    print_b "MySQL Governor installed successfully."
  else
    print_r "MySQL Governor installation is only supported on CloudLinux."
  fi
  pause_screen
}

cloudlinux_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${CloudLinux}\033[0m"
    print_g "1) Install CloudLinux"
    print_g "2) Install CageFS"
    print_g "3) Install alt-php"
    print_g "4) Install ea-php"
    print_g "5) Install mod-lsapi"
    print_g "6) Install Python"
    print_g "7) Install Ruby"
    print_g "8) Install NodeJS"
    print_g "9) Install MySQL Governor (not recommended)"
    print_g "10) Back to Menu"
    validate_menu_input "Enter your choice (1-10): " 1 10

    case "$INPUT" in
      1) clear_screen; install_cloudlinux ;;
      2) clear_screen; install_cagefs ;;
      3) clear_screen; install_alt_php ;;
      4) clear_screen; install_ea_php ;;
      5) clear_screen; install_mod_lsapi ;;
      6) clear_screen; install_cloudlinux_python ;;
      7) clear_screen; install_cloudlinux_ruby ;;
      8) clear_screen; install_cloudlinux_nodejs ;;
      9) clear_screen; install_mysql_governor ;;
      10) clear_screen; break ;;
    esac
  done
}

# -----------------------------
# cPanel FTP
# -----------------------------
cpanel_ftp_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${FTP}\033[0m"
    print_g "1) Pure-FTPd FTP Server (recommended)"
    print_g "2) ProFTP FTP Server"
    print_g "3) Disable FTP Services"
    print_g "4) Back to Menu"
    validate_menu_input "Enter your choice (1-4): " 1 4

    case "$INPUT" in
      1)
        /usr/local/cpanel/scripts/setupftpserver pure-ftpd
        print_b "Pure-FTPd configured successfully."
        pause_screen
        ;;
      2)
        /usr/local/cpanel/scripts/setupftpserver proftpd
        print_b "ProFTP configured successfully."
        pause_screen
        ;;
      3)
        /usr/local/cpanel/scripts/setupftpserver disabled
        print_b "FTP services disabled successfully."
        pause_screen
        ;;
      4)
        clear_screen
        break
        ;;
    esac
  done
}

# -----------------------------
# Advanced Tools
# -----------------------------
restore_backup_cpanel() {
  confirm_or_return "Are you sure you want to restore the user backup? (y/n):" || return 0

  local directory backup_link backup_file_name
  safe_read directory "Enter the home directory location (default /home): "
  [[ -n "$directory" ]] || directory="/home"

  cd "$directory" || { print_r "Cannot access $directory"; pause_screen; return 1; }
  safe_read backup_link "Enter backup link: "
  print_g "Downloading the backup file..."
  if [[ "$backup_link" != https://* ]]; then
    print_r "Only HTTPS backup links are accepted."
    pause_screen
    return 1
  fi
  local suggested_name
  suggested_name="${backup_link%%\?*}"
  suggested_name="${suggested_name##*/}"
  [[ -n "$suggested_name" ]] || suggested_name="cpanel-backup.tar.gz"
  safe_read backup_file_name "Enter backup file name (default $suggested_name): "
  [[ -n "$backup_file_name" ]] || backup_file_name="$suggested_name"
  download_file "$backup_link" "$backup_file_name" || return 1
  print_g "Restoring the backup file..."
  /usr/local/cpanel/scripts/restorepkg "$backup_file_name"
  pause_screen
}

clear_ram_cache() {
  confirm_or_return "Are you sure you want to clear RAM cache? (y/n):" || return 0
  sync
  echo 1 > /proc/sys/vm/drop_caches
  sync
  echo 2 > /proc/sys/vm/drop_caches
  sync
  echo 3 > /proc/sys/vm/drop_caches
  swapoff -a && swapon -a
  print_b "RAM cache cleared successfully."
  pause_screen
}

delete_error_logs_cpanel() {
  confirm_or_return "Are you sure you want to delete all error_log files? (y/n):" || return 0
  find /root -type f -name error_log -exec du -sh {} \; -exec rm -f {} \; 2>/dev/null
  find /home -type f -name error_log -exec du -sh {} \; -exec rm -f {} \; 2>/dev/null
  print_b "All error_log files deleted successfully."
  pause_screen
}

clear_tmp_dir() {
  confirm_or_return "Are you sure you want to clear /tmp? (y/n):" || return 0

  if is_centos_family; then
    case "$PKG_MANAGER" in
      yum) yum install -y tmpwatch ;;
      dnf) dnf install -y tmpwatch ;;
    esac
    /usr/sbin/tmpwatch --mtime --all 6 /tmp
    print_b "/tmp cleared successfully."
  elif is_ubuntu_family; then
    apt install -y tmpreaper
    tmpreaper 6h /tmp
    print_b "/tmp cleared successfully."
  else
    print_r "Unsupported OS for /tmp cleanup."
  fi
  pause_screen
}

advanced_tools_menu_cpanel() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${Advanced}\033[0m"
    print_g "1) Restore Backup"
    print_g "2) Clear RAM Cache"
    print_g "3) Delete all error_log"
    print_g "4) Clear /tmp"
    print_g "5) Back to Menu"
    validate_menu_input "Enter your choice (1-5): " 1 5

    case "$INPUT" in
      1) clear_screen; restore_backup_cpanel ;;
      2) clear_screen; clear_ram_cache ;;
      3) clear_screen; delete_error_logs_cpanel ;;
      4) clear_screen; clear_tmp_dir ;;
      5) clear_screen; break ;;
    esac
  done
}

advanced_tools_menu_plesk() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${Advanced}\033[0m"
    print_g "1) Clear RAM Cache"
    print_g "2) Delete all error_log"
    print_g "3) Clear /tmp"
    print_g "4) Back to Menu"
    validate_menu_input "Enter your choice (1-4): " 1 4

    case "$INPUT" in
      1) clear_screen; clear_ram_cache ;;
      2)
        clear_screen
        confirm_or_return "Are you sure you want to delete all error_log files? (y/n):" || continue
        find /root -type f -name error_log -exec du -sh {} \; -exec rm -f {} \; 2>/dev/null
        find /var -type f -name error_log -exec du -sh {} \; -exec rm -f {} \; 2>/dev/null
        find /home -type f -name error_log -exec du -sh {} \; -exec rm -f {} \; 2>/dev/null
        print_b "All error_log files deleted successfully."
        pause_screen
        ;;
      3) clear_screen; clear_tmp_dir ;;
      4) clear_screen; break ;;
    esac
  done
}

# -----------------------------
# cPanel Main
# -----------------------------
install_cpanel() {
  confirm_or_return "Are you sure you want to install cPanel? (y/n):" || return 0
  cd /home || return 1
  download_file https://securedownloads.cpanel.net/latest latest || return 1
  bash latest
}

cpanel_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${cPanel}\033[0m"
    print_y "What do you want to do?"
    print_g "1) Install cPanel"
    print_g "2) Server Tools [4]"
    print_g "3) Setup CSF [5]"
    print_g "4) Install Plugins [8]"
    print_g "5) Setup CloudLinux [9]"
    print_g "6) Setup FTP Server [3]"
    print_g "7) Advanced Tools [4]"
    print_g "8) Back to Menu"
    validate_menu_input "Enter your choice (1-8): " 1 8

    case "$INPUT" in
      1) clear_screen; echo -e "\033[0;32m${InstallcPanel}\033[0m"; install_cpanel ;;
      2) clear_screen; server_tools_menu ;;
      3) clear_screen; csf_menu ;;
      4) clear_screen; cpanel_plugins_menu ;;
      5) clear_screen; cloudlinux_menu ;;
      6) clear_screen; cpanel_ftp_menu ;;
      7) clear_screen; advanced_tools_menu_cpanel ;;
      8) clear_screen; break ;;
    esac
  done
}

# -----------------------------
# Plesk
# -----------------------------
install_plesk() {
  confirm_or_return "Are you sure you want to install Plesk? (y/n):" || return 0
  run_downloaded_script https://autoinstall.plesk.com/one-click-installer || return 1
}

install_litespeed_plesk() {
  confirm_or_return "Are you sure you want to install LiteSpeed? (y/n):" || return 0
  cd /usr/src || return 1
  download_file https://www.litespeedtech.com/packages/plesk/litespeed-plesk.zip litespeed-plesk.zip || return 1
  unzip -o litespeed-plesk.zip
  cd plib/resources || return 1
  chmod 700 pleskInstall.sh
  ./pleskInstall.sh
  rm -f pleskInstall.sh
  print_b "LiteSpeed installed successfully."
  pause_screen
}

plesk_plugins_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${Plugins}\033[0m"
    print_g "1) Install LiteSpeed"
    print_g "2) Install ImunifyAV"
    print_g "3) Install Softaculous"
    print_g "4) Install SitePad"
    print_g "5) Back to Menu"
    validate_menu_input "Enter your choice (1-5): " 1 5

    case "$INPUT" in
      1) clear_screen; install_litespeed_plesk ;;
      2) clear_screen; install_imunifyav ;;
      3) clear_screen; install_softaculous ;;
      4) clear_screen; install_sitepad ;;
      5) clear_screen; break ;;
    esac
  done
}

plesk_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${Plesk}\033[0m"
    print_y "What do you want to do?"
    print_g "1) Install Plesk"
    print_g "2) Server Tools [4]"
    print_g "3) Setup CSF [5]"
    print_g "4) Install Plugins [4]"
    print_g "5) Advanced Tools [3]"
    print_g "6) Back to Menu"
    validate_menu_input "Enter your choice (1-6): " 1 6

    case "$INPUT" in
      1) clear_screen; echo -e "\033[0;32m${InstallPlesk}\033[0m"; install_plesk ;;
      2) clear_screen; server_tools_menu ;;
      3) clear_screen; csf_menu ;;
      4) clear_screen; plesk_plugins_menu ;;
      5) clear_screen; advanced_tools_menu_plesk ;;
      6) clear_screen; break ;;
    esac
  done
}

# -----------------------------
# aaPanel helpers
# -----------------------------
aa_panel_service_menu() {
  local service_name="$1"
  local label="$2"
  local config_path="$3"
  local dir_path="$4"
  local service_exists_mode="$5"

  while true; do
    clear_screen
    print_y "Manage $label"
    print_g "1) Start $label"
    print_g "2) Stop $label"
    print_g "3) Restart $label"
    print_g "4) Reload $label"
    print_g "5) Status $label"
    print_g "6) Configuration $label"
    print_g "7) Open Directory $label"
    print_g "8) Back to Menu"
    validate_menu_input "Enter your choice (1-8): " 1 8

    case "$INPUT" in
      1)
        confirm_or_return "Are you sure you want to start $label? (y/n):" || continue
        if aa_service_available "$service_exists_mode" "$service_name" "$dir_path"; then
          service_action "$service_name" start
          print_g "$label started successfully."
        else
          print_r "$label is not installed."
        fi
        pause_screen
        ;;
      2)
        confirm_or_return "Are you sure you want to stop $label? (y/n):" || continue
        if aa_service_available "$service_exists_mode" "$service_name" "$dir_path"; then
          service_action "$service_name" stop
          print_g "$label stopped successfully."
        else
          print_r "$label is not installed."
        fi
        pause_screen
        ;;
      3)
        confirm_or_return "Are you sure you want to restart $label? (y/n):" || continue
        if aa_service_available "$service_exists_mode" "$service_name" "$dir_path"; then
          service_action "$service_name" restart
          print_g "$label restarted successfully."
        else
          print_r "$label is not installed."
        fi
        pause_screen
        ;;
      4)
        confirm_or_return "Are you sure you want to reload $label? (y/n):" || continue
        if aa_service_available "$service_exists_mode" "$service_name" "$dir_path"; then
          service_action "$service_name" reload
          print_g "$label reloaded successfully."
        else
          print_r "$label is not installed."
        fi
        pause_screen
        ;;
      5)
        confirm_or_return "Are you sure you want to view status of $label? (y/n):" || continue
        if aa_service_available "$service_exists_mode" "$service_name" "$dir_path"; then
          systemctl status "$service_name"
        else
          print_r "$label is not installed."
        fi
        pause_screen
        ;;
      6)
        confirm_or_return "Are you sure you want to configure $label? (y/n):" || continue
        if aa_service_available "$service_exists_mode" "$service_name" "$dir_path"; then
          editor_menu "$config_path"
        else
          print_r "$label is not installed."
          pause_screen
        fi
        ;;
      7)
        confirm_or_return "Are you sure you want to open directory of $label? (y/n):" || continue
        if aa_service_available "$service_exists_mode" "$service_name" "$dir_path"; then
          cd "$dir_path" || { print_r "Cannot open $dir_path"; pause_screen; continue; }
          ls
        else
          print_r "$label is not installed."
        fi
        pause_screen
        ;;
      8)
        break
        ;;
    esac
  done
}

aa_service_available() {
  local mode="$1"
  local service_name="$2"
  local dir_path="$3"

  if [[ "$mode" == "command" ]]; then
    command_exists "$service_name"
  else
    [[ -d "$dir_path" ]]
  fi
}

editor_menu() {
  local target_file="$1"
  while true; do
    clear_screen
    print_g "1) nano editor"
    print_g "2) vi editor"
    print_g "3) vim editor"
    print_g "4) Back to Menu"
    validate_menu_input "Enter your choice (1-4): " 1 4

    case "$INPUT" in
      1) nano "$target_file" ;;
      2) vi "$target_file" ;;
      3) vim "$target_file" ;;
      4) break ;;
    esac
  done
}

install_aapanel() {
  confirm_or_return "Are you sure you want to install aaPanel? (y/n):" || return 0

  if is_centos_family; then
    case "$PKG_MANAGER" in
      yum) yum install -y wget ;;
      dnf) dnf install -y wget ;;
    esac
    run_downloaded_script https://www.aapanel.com/script/install_6.0_en.sh aapanel || return 1
    print_g "aaPanel installed successfully. Please login to panel."
  elif [[ "$OS_ID" == "ubuntu" ]]; then
    run_downloaded_script https://www.aapanel.com/script/install-ubuntu_6.0_en.sh aapanel || return 1
    print_g "aaPanel installed successfully. Please login to panel."
  elif [[ "$OS_ID" == "debian" ]]; then
    run_downloaded_script https://www.aapanel.com/script/install-ubuntu_6.0_en.sh aapanel || return 1
    print_g "aaPanel installed successfully. Please login to panel."
  else
    print_r "aaPanel installation is only supported on CentOS-like, Ubuntu, Debian."
  fi
  pause_screen
}

aa_management_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${Management}\033[0m"
    print_g "1) Start aaPanel"
    print_g "2) Stop aaPanel"
    print_g "3) Restart aaPanel"
    print_g "4) Uninstall aaPanel"
    print_g "5) Change Password aaPanel"
    print_g "6) View Current Port"
    print_g "7) Change Port aaPanel"
    print_g "8) Turn off SSL aaPanel"
    print_g "9) View Error logs aaPanel"
    print_g "10) View Error logs Site"
    print_g "11) Back to Menu"
    validate_menu_input "Enter your choice (1-11): " 1 11

    case "$INPUT" in
      1)
        confirm_or_return "Are you sure you want to start aaPanel? (y/n):" || continue
        service_action bt start
        print_g "aaPanel started successfully."
        pause_screen
        ;;
      2)
        confirm_or_return "Are you sure you want to stop aaPanel? (y/n):" || continue
        service_action bt stop
        print_g "aaPanel stopped successfully."
        pause_screen
        ;;
      3)
        confirm_or_return "Are you sure you want to restart aaPanel? (y/n):" || continue
        service_action bt restart
        print_g "aaPanel restarted successfully."
        pause_screen
        ;;
      4)
        confirm_or_return "Are you sure you want to uninstall aaPanel? (y/n):" || continue
        service_action bt stop || true
        chkconfig --del bt 2>/dev/null || true
        rm -f /etc/init.d/bt
        rm -rf /www/server/panel
        print_g "aaPanel uninstalled successfully."
        pause_screen
        ;;
      5)
        confirm_or_return "Are you sure you want to change aaPanel password? (y/n):" || continue
        local pass
        safe_read pass "Enter Password: "
        cd /www/server/panel || { print_r "aaPanel path not found."; pause_screen; continue; }
        python tools.py panel "$pass"
        print_b "Password changed successfully."
        pause_screen
        ;;
      6)
        confirm_or_return "Are you sure you want to view current port? (y/n):" || continue
        cat /www/server/panel/data/port.pl
        pause_screen
        ;;
      7)
        confirm_or_return "Are you sure you want to change aaPanel port? (y/n):" || continue
        local port
        safe_read port "Enter aaPanel Port: "
        if validate_port "$port"; then
          echo "$port" > /www/server/panel/data/port.pl
          service_action bt restart
          if command_exists firewall-cmd; then
            firewall-cmd --permanent --zone=public --add-port="${port}/tcp"
            firewall-cmd --reload
          fi
          print_g "aaPanel port changed successfully to -> $port"
        else
          print_r "Invalid port."
        fi
        pause_screen
        ;;
      8)
        confirm_or_return "Are you sure you want to turn off SSL for aaPanel? (y/n):" || continue
        rm -f /www/server/panel/data/ssl.pl
        /etc/init.d/bt restart 2>/dev/null || service_action bt restart
        print_g "aaPanel SSL disabled successfully."
        pause_screen
        ;;
      9)
        confirm_or_return "Are you sure you want to view aaPanel error logs? (y/n):" || continue
        cat /tmp/panelBoot 2>/dev/null || print_r "Log file not found."
        pause_screen
        ;;
      10)
        confirm_or_return "Are you sure you want to view site error logs? (y/n):" || continue
        ls -lah /www/wwwlogs 2>/dev/null || print_r "Site logs directory not found."
        pause_screen
        ;;
      11)
        break
        ;;
    esac
  done
}

aa_webserver_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${WebServer}\033[0m"
    print_y "Select your Web Server type"
    print_g "1) Setup Nginx [7]"
    print_g "2) Setup Apache [7]"
    print_g "3) Back to Menu"
    validate_menu_input "Enter your choice (1-3): " 1 3

    case "$INPUT" in
      1) aa_panel_service_menu nginx Nginx /www/server/nginx/conf/nginx.conf /www/server/nginx command ;;
      2) aa_panel_service_menu "$APACHE_SERVICE" Apache /www/server/apache/conf/httpd.conf /www/server/httpd command ;;
      3) break ;;
    esac
  done
}

aa_mysql_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${Mysql}\033[0m"
    print_g "1) Start Mysql"
    print_g "2) Stop Mysql"
    print_g "3) Restart Mysql"
    print_g "4) Reload Mysql"
    print_g "5) Status Mysql"
    print_g "6) Change Password MySQL"
    print_g "7) Configuration Mysql"
    print_g "8) Open Directory Mysql"
    print_g "9) Open Directory phpMyAdmin"
    print_g "10) Open Directory Data Storage"
    print_g "11) Back to Menu"
    validate_menu_input "Enter your choice (1-11): " 1 11

    case "$INPUT" in
      1|2|3|4|5)
        local action
        case "$INPUT" in
          1) action="start" ;;
          2) action="stop" ;;
          3) action="restart" ;;
          4) action="reload" ;;
          5) action="status" ;;
        esac
        confirm_or_return "Are you sure you want to ${action} MySQL? (y/n):" || continue
        if command_exists mysql; then
          if [[ "$action" == "status" ]]; then
            systemctl status "$MYSQL_SERVICE"
          else
            service_action "$MYSQL_SERVICE" "$action"
            print_g "Mysql ${action}ed successfully."
          fi
        else
          print_r "Mysql is not installed."
        fi
        pause_screen
        ;;
      6)
        confirm_or_return "Are you sure you want to change MySQL password? (y/n):" || continue
        if command_exists mysql; then
          local pass
          safe_read pass "Enter Password: "
          cd /www/server/panel || { print_r "aaPanel path not found."; pause_screen; continue; }
          python3 tools.py root "$pass"
          print_b "Password changed successfully."
        else
          print_r "Mysql is not installed."
        fi
        pause_screen
        ;;
      7)
        confirm_or_return "Are you sure you want to configure MySQL? (y/n):" || continue
        if command_exists mysql; then
          editor_menu /etc/my.cnf
        else
          print_r "Mysql is not installed."
          pause_screen
        fi
        ;;
      8)
        confirm_or_return "Are you sure you want to open MySQL directory? (y/n):" || continue
        if command_exists mysql; then cd /www/server/mysql && ls; else print_r "Mysql is not installed."; fi
        pause_screen
        ;;
      9)
        confirm_or_return "Are you sure you want to open phpMyAdmin directory? (y/n):" || continue
        if command_exists mysql; then cd /www/server/phpmyadmin && ls; else print_r "Mysql is not installed."; fi
        pause_screen
        ;;
      10)
        confirm_or_return "Are you sure you want to open Data Storage directory? (y/n):" || continue
        if command_exists mysql; then cd /www/server/data && ls; else print_r "Mysql is not installed."; fi
        pause_screen
        ;;
      11)
        break
        ;;
    esac
  done
}

aa_ftp_menu() {
  aa_panel_service_menu pure-ftpd FTP /www/server/pure-ftpd/etc/pure-ftpd /www/server/pure-ftpd directory
}

aa_redis_menu() {
  aa_panel_service_menu redis Redis /www/server/redis/redis.conf /www/server/redis directory
}

aa_memcached_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${Memcached}\033[0m"
    print_g "1) Start Memcached"
    print_g "2) Stop Memcached"
    print_g "3) Restart Memcached"
    print_g "4) Reload Memcached"
    print_g "5) Status Memcached"
    print_g "6) Open Directory Memcached"
    print_g "7) Back to Menu"
    validate_menu_input "Enter your choice (1-7): " 1 7

    case "$INPUT" in
      1|2|3|4|5)
        local action
        case "$INPUT" in
          1) action="start" ;;
          2) action="stop" ;;
          3) action="restart" ;;
          4) action="reload" ;;
          5) action="status" ;;
        esac
        confirm_or_return "Are you sure you want to ${action} Memcached? (y/n):" || continue
        if [[ -d /usr/local/memcached ]]; then
          if [[ "$action" == "status" ]]; then
            systemctl status memcached
          else
            service_action memcached "$action"
            print_g "Memcached ${action}ed successfully."
          fi
        else
          print_r "Memcached is not installed."
        fi
        pause_screen
        ;;
      6)
        confirm_or_return "Are you sure you want to open Memcached directory? (y/n):" || continue
        if [[ -d /usr/local/memcached ]]; then
          cd /usr/local/memcached && ls
        else
          print_r "Memcached is not installed."
        fi
        pause_screen
        ;;
      7)
        break
        ;;
    esac
  done
}

aa_panel_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${aaPanel}\033[0m"
    print_y "What do you want to do?"
    print_g "1) Install aaPanel"
    print_g "2) Server Tools [4]"
    print_g "3) Setup Management [10]"
    print_g "4) Setup WebServer [2]"
    print_g "5) Setup Mysql [10]"
    print_g "6) Setup FTP [7]"
    print_g "7) Setup Redis [7]"
    print_g "8) Setup Memcached [6]"
    print_g "9) Back to Menu"
    validate_menu_input "Enter your choice (1-9): " 1 9

    case "$INPUT" in
      1) clear_screen; echo -e "\033[0;32m${InstallaaPanel}\033[0m"; install_aapanel ;;
      2) clear_screen; server_tools_menu ;;
      3) clear_screen; aa_management_menu ;;
      4) clear_screen; aa_webserver_menu ;;
      5) clear_screen; aa_mysql_menu ;;
      6) clear_screen; aa_ftp_menu ;;
      7) clear_screen; aa_redis_menu ;;
      8) clear_screen; aa_memcached_menu ;;
      9) clear_screen; break ;;
    esac
  done
}

# -----------------------------
# Main Menu
# -----------------------------
main_menu() {
  while true; do
    clear_screen
    echo -e "\033[0;32m${message}\033[0m"
    echo -e "\033[34mInformation Server\033[0m"
    information
    echo
    print_y "Which control panel do you want to manage or install?"
    print_g "1) cPanel"
    print_g "2) Plesk"
    print_g "3) aaPanel"
    print_g "4) Exit"
    validate_menu_input "Enter your choice (1-4): " 1 4

    case "$INPUT" in
      1) cpanel_menu ;;
      2) plesk_menu ;;
      3) aa_panel_menu ;;
      4) clear_screen; exit 0 ;;
    esac
  done
}

# -----------------------------
# Bootstrap
# -----------------------------
usage() {
  cat <<EOF
$APP_NAME $VERSION

Usage: $0 [options]
  --check          Run compatibility checks and exit
  --update         Update system packages during startup
  --skip-update    Do not update system packages (default)
  --no-color       Disable colored output
  --version        Show version and exit
  -h, --help       Show this help
EOF
}

parse_arguments() {
  while (( $# > 0 )); do
    case "$1" in
      --check) CHECK_ONLY=1 ;;
      --update) AUTO_UPDATE=1 ;;
      --skip-update) AUTO_UPDATE=0 ;;
      --no-color) BLUE=''; RED=''; YELLOW=''; GREEN=''; NC='' ;;
      --version) printf '%s %s\n' "$APP_NAME" "$VERSION"; exit 0 ;;
      -h|--help) usage; exit 0 ;;
      *) print_r "Unknown option: $1"; usage; exit 2 ;;
    esac
    shift
  done
}

main() {
  parse_arguments "$@"
  require_root
  load_os_info
  collect_server_info
  log_message INFO "Starting $APP_NAME $VERSION on $OPERATING_SYSTEM"
  if (( CHECK_ONLY == 1 )); then
    system_check
    exit $?
  fi
  update_system_packages
  main_menu
}

main "$@"
