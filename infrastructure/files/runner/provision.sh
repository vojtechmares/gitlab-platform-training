#!/usr/bin/env bash
# First-boot provisioning of the runner VM. Called once by cloud-init (runcmd).
# Progress: tail -f /var/log/training-provision.log
set -euo pipefail

exec > >(tee -a /var/log/training-provision.log) 2>&1
log() { echo "[provision $(date -u +%H:%M:%S)] $*"; }

# shellcheck disable=SC1091
source /etc/training/env
# shellcheck disable=SC1091
. /etc/os-release

log "moving host sshd to port ${SSH_PORT}"
/usr/local/sbin/training-move-sshd

log "installing Docker Engine"
/usr/local/sbin/training-install-docker

# GitLab Runner from GitLab's own apt repository (signed), without piping a script into a shell.
log "installing GitLab Runner"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://packages.gitlab.com/runner/gitlab-runner/gpgkey \
  | gpg --dearmor -o /etc/apt/keyrings/gitlab-runner.gpg
cat > /etc/apt/sources.list.d/gitlab-runner.list <<LIST
deb [signed-by=/etc/apt/keyrings/gitlab-runner.gpg] https://packages.gitlab.com/runner/gitlab-runner/${ID}/ ${VERSION_CODENAME} main
LIST
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y gitlab-runner

# Registration needs GitLab to be up, which takes minutes. A separate unit retries until it is.
systemctl enable --now --no-block training-runner-bootstrap.service
log "done. The runner registers itself once GitLab is ready: journalctl -fu training-runner-bootstrap"
