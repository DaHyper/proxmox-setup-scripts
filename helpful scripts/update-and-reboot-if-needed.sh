#!/bin/bash
apt-get update && apt-get -y dist-upgrade
if [ -f /var/run/reboot-required ]; then
  echo "Reboot required. Rebooting..."
  reboot
else
  echo "No reboot required."
fi