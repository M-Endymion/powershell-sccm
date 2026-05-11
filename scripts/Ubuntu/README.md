# Ubuntu Server Scripts

This folder contains scripts and tools for **quick, clean, and secure Ubuntu server deployments** — perfect for homelabs, self-hosting, and small enterprise setups.

---

### Scripts

| Script Name                        | Description                                                                 | Key Features |
|------------------------------------|-----------------------------------------------------------------------------|--------------|
| `Ubuntu-Server-QuickDeploy.sh`     | One-script Ubuntu server setup for homelab use                              | Docker, Portainer, Tailscale, Watchtower, Fail2Ban, MOTD |

---

### Usage

Make the script executable and run it:

```bash
chmod +x Ubuntu-Server-QuickDeploy.sh
sudo ./Ubuntu-Server-QuickDeploy.sh
```

---

## What This Script Sets Up

- Docker + Docker Compose
- Portainer (web UI for Docker management) on port 9000
- Watchtower (automatic container updates)
- Tailscale (secure zero-config VPN)
- Fail2Ban (brute-force protection)
- Clean MOTD + useful system tweaks
- Optional ZFS setup

---

## After Running the Script

1. Run sudo tailscale up and authenticate with your Tailscale account
2. Access Portainer at http://YOUR_SERVER_IP:9000
3. (Optional) Set up ZFS pools manually if desired

---

## Ideal For

- New homelab servers
- Self-hosting (Jellyfin, *arr stack, Nextcloud, etc.)
- Secure remote access via Tailscale
- Quick provisioning of Ubuntu VMs or bare metal

---

## Requirements

- Fresh Ubuntu 22.04 or 24.04 LTS server
- Root or sudo access
- Internet connection

---

## Future Scripts (Planned)

- Deploy-MediaStack.sh — Jellyfin + *arr stack + Nginx Proxy Manager
- Ubuntu-Security-Hardening.sh
- Monitor-Setup.sh (Prometheus + Grafana + Node Exporter)
- Backup-Solution.sh

___

Note: These scripts are designed to be safe and idempotent. Always review before running on production systems.
