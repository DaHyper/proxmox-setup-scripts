# Proxmox Setup Scripts

Just a few small scripts I use after installing Proxmox VE.

Originally I used [TTeck’s excellent community scripts](https://community-scripts.github.io/ProxmoxVE/) (RIP ❤️), but had some security concerns about running code straight from the internet as root.

So I wrote my own.

### What does it do?

Primarily, this disables the Proxmox subscription nag.

In addition, it includes an unattended ISO for Windows 10/11 deployments and several other handy scripts to make your life easier.
That’s it.

### Usage

```bash
wget https://raw.githubusercontent.com/DaHyper/proxmox-setup-scripts/main/postpveinstall-disablenag.sh
chmod +x postpveinstall-disablenag.sh
sudo ./postpveinstall-disablenag.sh
