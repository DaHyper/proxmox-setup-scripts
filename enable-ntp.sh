#!/bin/bash
apt-get install -y chrony
systemctl enable --now chrony
echo "NTP time sync enabled with Chrony."