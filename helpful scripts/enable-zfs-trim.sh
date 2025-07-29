#!/bin/bash
systemctl enable --now zfs-trim.timer
echo "ZFS TRIM enabled."