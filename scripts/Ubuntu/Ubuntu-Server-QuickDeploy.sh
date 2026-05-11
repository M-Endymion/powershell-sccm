#!/bin/bash
# =============================================================================
# Ubuntu Server Quick Deploy
# Docker + Portainer + Tailscale + ZFS Setup
# Author: M-Endymion
# Version: 1.0
# =============================================================================

set -euo pipefail

echo "🚀 Starting Ubuntu Server Quick Deploy..."

# Update system
echo "📦 Updating system packages..."
apt update && apt upgrade -y

# Install essential tools
echo "🔧 Installing essential packages..."
apt install -y curl wget git unzip htop ca-certificates

# =============================================================================
# ZFS Setup
# =============================================================================
echo "💾 Setting up ZFS..."
apt install -y zfsutils-linux

# Create a ZFS pool if drives are available (example: using /dev/sdb)
if ls /dev/sd* > /dev/null 2>&1; then
    echo "Found disks. Would you like to create a ZFS pool? (y/n)"
    read -r create_zfs
    if [[ "$create_zfs" == "y" ]]; then
        zpool create -f tank /dev/sdb
        zfs create tank/docker
        echo "✅ ZFS pool 'tank' created with docker dataset"
    fi
fi

# =============================================================================
# Docker Setup
# =============================================================================
echo "🐳 Installing Docker..."
apt install -y docker.io docker-compose-plugin
systemctl enable --now docker

# Add current user to docker group
usermod -aG docker $USER

# =============================================================================
# Portainer Setup
# =============================================================================
echo "📊 Installing Portainer..."
docker volume create portainer_data

docker run -d \
  --name portainer \
  --restart=always \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo "✅ Portainer installed and running on port 9000"

# =============================================================================
# Tailscale Setup
# =============================================================================
echo "🌐 Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

echo "✅ Tailscale installed."
echo "Run 'sudo tailscale up' to authenticate and join your network."

# =============================================================================
# Final Summary
# =============================================================================
echo ""
echo "🎉 Ubuntu Server Quick Deploy Completed!"
echo ""
echo "══════════════════════════════════════"
echo "Access URLs:"
echo "• Portainer: http://$(hostname -I | awk '{print $1}'):9000"
echo "• Tailscale: Run 'tailscale status' after authentication"
echo "══════════════════════════════════════"
echo ""
echo "Next steps:"
echo "1. Reboot recommended"
echo "2. Run: tailscale up"
echo "3. Access Portainer at port 9000"
echo ""

# Save log
echo "Deployment completed at $(date)" >> ~/ubuntu-quickdeploy.log
