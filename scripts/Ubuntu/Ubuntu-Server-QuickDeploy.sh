#!/bin/bash
# =============================================================================
# Ubuntu Server Quick Deploy - Homelab Edition
# Docker + Portainer + Tailscale + Monitoring + Security
# Author: M-Endymion
# Version: 1.1
# =============================================================================

set -euo pipefail

echo "🚀 Starting Ubuntu Server Quick Deploy - Homelab Edition"

# Update system
apt update && apt upgrade -y

# Essential packages
apt install -y curl wget git unzip htop ca-certificates fail2ban

# =============================================================================
# Docker Setup
# =============================================================================
echo "🐳 Installing Docker..."
apt install -y docker.io docker-compose-plugin
systemctl enable --now docker
usermod -aG docker $USER
echo "✅ Docker installed and user added to docker group"

# =============================================================================
# Portainer
# =============================================================================
echo "📊 Installing Portainer..."
docker volume create portainer_data >/dev/null 2>&1 || true

docker run -d \
  --name portainer \
  --restart=always \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo "✅ Portainer installed → http://$(hostname -I | awk '{print $1}'):9000"

# =============================================================================
# Watchtower (Auto-update containers)
# =============================================================================
echo "🔄 Installing Watchtower (auto-updates)..."
docker run -d \
  --name watchtower \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower --schedule "0 0 * * *" --cleanup

echo "✅ Watchtower installed (updates containers daily)"

# =============================================================================
# Tailscale
# =============================================================================
echo "🌐 Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh
echo "✅ Tailscale installed."
echo "→ Run: 'sudo tailscale up' to connect to your Tailscale network"

# =============================================================================
# Optional ZFS
# =============================================================================
echo -e "\n💾 Would you like to setup ZFS? (y/n)"
read -r setup_zfs
if [[ "$setup_zfs" == "y" ]]; then
    apt install -y zfsutils-linux
    echo "ZFS installed. You can create pools manually (e.g. zpool create tank /dev/sdX)"
else
    echo "Skipping ZFS setup."
fi

# =============================================================================
# Security & Monitoring
# =============================================================================
echo "🔒 Enabling Fail2Ban..."
systemctl enable --now fail2ban

# Nice MOTD
echo "Setting up nice MOTD..."
echo "Welcome to $(hostname) - Homelab Server" > /etc/motd

# =============================================================================
# Final Summary
# =============================================================================
echo ""
echo "🎉 Deployment Completed Successfully!"
echo ""
echo "══════════════════════════════════════"
echo "Useful Commands:"
echo "• Portainer     → http://$(hostname -I | awk '{print $1}'):9000"
echo "• Tailscale     → sudo tailscale up"
echo "• Watchtower    → Auto-updates containers"
echo "• Fail2Ban      → Active"
echo "══════════════════════════════════════"
echo ""

echo "Deployment log saved to ~/ubuntu-quickdeploy.log"
echo "Deployment completed at $(date)" >> ~/ubuntu-quickdeploy.log
