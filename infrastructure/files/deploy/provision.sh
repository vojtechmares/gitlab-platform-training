#!/usr/bin/env bash
# First-boot provisioning of the deploy host: a plain Docker host that pipelines deploy to.
# Progress: tail -f /var/log/training-provision.log
set -euo pipefail

exec > >(tee -a /var/log/training-provision.log) 2>&1
log() { echo "[provision $(date -u +%H:%M:%S)] $*"; }

# shellcheck disable=SC1091
source /etc/training/env

log "moving host sshd to port ${SSH_PORT}"
/usr/local/sbin/training-move-sshd

log "installing Docker Engine"
/usr/local/sbin/training-install-docker

# Membership of the docker group is equivalent to root on this host. That is the point of
# the "who holds the deploy key" discussion in the training.
usermod -aG docker deploy

log "done"
