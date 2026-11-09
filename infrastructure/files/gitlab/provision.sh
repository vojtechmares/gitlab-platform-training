#!/usr/bin/env bash
# First-boot provisioning of the GitLab VM. Called once by cloud-init (runcmd).
# Progress: tail -f /var/log/training-provision.log
set -euo pipefail

exec > >(tee -a /var/log/training-provision.log) 2>&1
log() { echo "[provision $(date -u +%H:%M:%S)] $*"; }

# shellcheck disable=SC1091
source /etc/training/env

# 1. Move the host's sshd away from port 22. Must happen BEFORE the GitLab container
#    starts, because the container publishes port 22 for Git over SSH.
log "moving host sshd to port ${SSH_PORT}"
/usr/local/sbin/training-move-sshd

# 2. Swap as a safety net.
if [ "${SWAP_GB}" -gt 0 ] && [ ! -f /swapfile ]; then
  log "creating ${SWAP_GB} GB swap file"
  fallocate -l "${SWAP_GB}G" /swapfile
  chmod 600 /swapfile
  mkswap /swapfile >/dev/null
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
  echo 'vm.swappiness=10' > /etc/sysctl.d/99-gitlab.conf
  sysctl -q --system
fi

# 3. Data directories (config/ already holds gitlab.rb).
mkdir -p /srv/gitlab/config /srv/gitlab/logs /srv/gitlab/data

# 4. Pull images first, so systemd's start timeout does not have to cover the download.
log "pulling images (GitLab is about 3 GB)"
podman pull "${GITLAB_IMAGE}"
podman pull docker.io/library/caddy:2

# 5. Let Quadlet turn /etc/containers/systemd/*.container into services, and start them.
log "starting GitLab and Caddy"
systemctl daemon-reload
systemctl start gitlab.service
systemctl start caddy.service

# 6. Create the bootstrap token and apply settings once GitLab is ready.
#    Runs as its own unit with retries: the first GitLab start takes 5-10 minutes.
systemctl enable --now --no-block training-gitlab-bootstrap.service

log "done. GitLab is still starting; check: podman logs -f gitlab"
