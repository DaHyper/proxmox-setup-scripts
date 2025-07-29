#!/usr/bin/env bash

set -euo pipefail
shopt -s inherit_errexit nullglob

# Basic color output
GREEN="\033[1;92m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"
CHECK="${GREEN}✓${RESET}"
CROSS="${RED}✗${RESET}"

info() {
  echo -e "${YELLOW}[*] $1${RESET}"
}

ok() {
  echo -e "${CHECK} $1"
}

fail() {
  echo -e "${CROSS} $1"
}

# Add pve-no-subscription repository
info "Setting up 'pve-no-subscription' repository"
cat <<EOF >/etc/apt/sources.list.d/pve-install-repo.list
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
EOF
ok "Enabled 'pve-no-subscription' repository"

# Comment out enterprise repo
info "Disabling 'pve-enterprise' repository"
echo "# deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise" >/etc/apt/sources.list.d/pve-enterprise.list
ok "Disabled 'pve-enterprise' repository"

# Ask if user wants to disable the subscription nag
read -p "Do you want to disable the PVE Subscription Nag? (Y/N): " disable_nag
case "$disable_nag" in
  [Yy]*)
    info "Disabling subscription nag"
    echo "DPkg::Post-Invoke { \"if [ -s /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js ] && ! grep -q -F 'NoMoreNagging' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js; then echo 'Removing subscription nag from UI...'; sed -i '/data\.status/{s/\\!//;s/active/NoMoreNagging/}' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js; fi\" };" >/etc/apt/apt.conf.d/no-nag-script
    ok "Disabled subscription nag (clear browser cache if needed)"
    ;;
  *)
    info "Subscription nag will remain enabled"
    rm -f /etc/apt/apt.conf.d/no-nag-script 2>/dev/null || true
    ;;
esac

# Update system
info "Updating Proxmox VE"
apt-get update -qq
apt-get -y dist-upgrade -qq
ok "System updated"

# Ask to reboot
read -p "Reboot Proxmox VE now? (Y/N): " reboot_choice
case "$reboot_choice" in
  [Yy]*)
    ok "Rebooting system..."
    sleep 2
    reboot
    ;;
  *)
    ok "Setup complete. Reboot recommended!"
    ;;
esac
