#!/usr/bin/env bash
# Move the host's sshd to $SSH_PORT. On the GitLab VM this frees port 22 for the
# GitLab container (Git over SSH). The drop-in /etc/ssh/sshd_config.d/10-training.conf
# is written by cloud-init before this runs.
set -euo pipefail

# shellcheck disable=SC1091
source /etc/training/env

# Refuse to continue with a broken configuration: a bad sshd_config + restart = locked out.
sshd -t

# Ubuntu starts sshd through socket activation, where "Port" in sshd_config is ignored.
# Switch to the plain service so the drop-in applies. (Debian does not use ssh.socket.)
if systemctl is-enabled --quiet ssh.socket 2>/dev/null; then
  systemctl disable --now ssh.socket
fi
systemctl enable ssh.service >/dev/null 2>&1 || true
systemctl restart ssh.service

# Verify before anything else depends on it.
for _ in $(seq 1 15); do
  if ss -ltn "sport = :${SSH_PORT}" | grep -q LISTEN; then
    echo "sshd listens on ${SSH_PORT}"
    if ss -ltn "sport = :22" | grep -q LISTEN; then
      echo "ERROR: something still listens on port 22" >&2
      exit 1
    fi
    exit 0
  fi
  sleep 1
done

echo "ERROR: sshd is not listening on ${SSH_PORT}" >&2
exit 1
