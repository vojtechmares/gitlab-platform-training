output "gitlab_url" {
  description = "GitLab web UI and Git over HTTPS. Reachable once the first start has finished (5-10 minutes after the VM boots)."
  value       = local.gitlab_url
}

output "registry_host" {
  description = "Container Registry host name (docker login <this>)."
  value       = local.registry_fqdn
}

output "admin_username" {
  description = "User name of the first GitLab administrator (renamed from 'root' when admin_username is set)."
  value       = var.admin_username
}

output "root_password" {
  description = "Initial password of the first administrator (admin_username; 'root' by default). Change it after the first sign-in."
  value       = random_password.root.result
  sensitive   = true
}

output "ip_addresses" {
  value = {
    gitlab = local.gitlab_ip
    runner = local.runner_ip
    deploy = local.deploy_ip
  }
}

output "ssh" {
  description = "Host SSH (port moved off 22). Git over SSH uses the normal port 22 on the GitLab VM."
  value = {
    gitlab = "ssh -p ${var.ssh_port} root@${local.gitlab_ip}"
    runner = "ssh -p ${var.ssh_port} root@${local.runner_ip}"
    deploy = var.enable_deploy_host ? "ssh -p ${var.ssh_port} root@${local.deploy_ip}" : null
  }
}

output "dns_records_to_create" {
  description = "Only when you use base_domain without dns_zone or cloudflare_zone: create these A records yourself, before or right after apply."
  value = local.use_domain && var.dns_zone == "" && var.cloudflare_zone == "" ? {
    (local.gitlab_fqdn)   = local.gitlab_ip
    (local.registry_fqdn) = local.gitlab_ip
  } : {}
}

output "watch_progress" {
  description = "Provisioning logs while the VMs come up."
  value = {
    gitlab_cloud_init = "ssh -p ${var.ssh_port} root@${local.gitlab_ip} tail -f /var/log/training-provision.log"
    gitlab_container  = "ssh -p ${var.ssh_port} root@${local.gitlab_ip} podman logs -f gitlab"
    runner_bootstrap  = "ssh -p ${var.ssh_port} root@${local.runner_ip} journalctl -fu training-runner-bootstrap"
  }
}

# Values the Day 2 pipeline needs as CI/CD variables. scripts/seed-training-data.sh reads this.
output "deploy_target" {
  description = "Connection details of the deploy host, used as CI/CD variables in Chapter 7."
  value = var.enable_deploy_host ? {
    host     = local.deploy_ip
    ssh_port = var.ssh_port
    user     = "deploy"
  } : null
}

output "deploy_ssh_private_key" {
  description = "Private key for the 'deploy' user on the deploy host (CI/CD variable SSH_PRIVATE_KEY, type File). terraform output -raw deploy_ssh_private_key"
  value       = tls_private_key.deploy.private_key_openssh
  sensitive   = true
}

output "ssh_port" {
  description = "SSH port of the VMs themselves."
  value       = var.ssh_port
}
