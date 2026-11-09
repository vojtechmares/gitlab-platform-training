#!/usr/bin/env bash
# Wait for GitLab, then create the bootstrap token (see bootstrap.rb).
# Runs as training-gitlab-bootstrap.service; safe to run repeatedly.
set -euo pipefail

# shellcheck disable=SC1091
source /etc/training/env

echo "waiting for GitLab to become ready (the first start takes 5-10 minutes)"
# /-/readiness only answers allowlisted addresses (localhost), so ask from inside the container.
until podman exec gitlab curl -fsS -o /dev/null http://127.0.0.1/-/readiness 2>/dev/null; do
  sleep 15
done

echo "GitLab is ready, running bootstrap.rb"
podman exec -e BOOTSTRAP_TOKEN="${BOOTSTRAP_TOKEN}" -e ADMIN_USERNAME="${ADMIN_USERNAME}" -e ADMIN_EMAIL="${ADMIN_EMAIL}" \
  gitlab gitlab-rails runner /etc/gitlab/bootstrap.rb
# One-shot: the unit has ConditionPathExists=! on this file, so a reboot does not run it again.
mkdir -p /var/lib/training
touch /var/lib/training/gitlab-bootstrap.done
echo "bootstrap finished"
