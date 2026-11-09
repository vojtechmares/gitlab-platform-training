########################################################################################
# Required
########################################################################################

variable "hcloud_token" {
  description = "Hetzner Cloud API token (project > Security > API tokens, read & write)."
  type        = string
  sensitive   = true
}

########################################################################################
# Access
########################################################################################

variable "ssh_public_key_file" {
  description = "Public SSH key installed for root on every VM. Use the key you will log in with."
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "existing_ssh_key_name" {
  description = <<-EOT
    Name of an SSH key that is ALREADY in the Hetzner project and is the one in ssh_public_key_file.
    Hetzner rejects a second upload of the same key (409 uniqueness_error), so set this instead.
    scripts/preflight.sh tells you when it is needed. Leave empty to upload the key.
  EOT
  type        = string
  default     = ""
}

variable "ssh_port" {
  description = "SSH port of the VMs themselves. Must not be 22: on the GitLab VM port 22 belongs to GitLab (Git over SSH)."
  type        = number
  default     = 6022

  validation {
    condition     = var.ssh_port != 22 && var.ssh_port > 1023 && var.ssh_port < 65536
    error_message = "ssh_port must be an unprivileged port other than 22."
  }
}

variable "admin_cidrs" {
  description = <<-EOT
    Networks allowed to reach the VMs' SSH port. The default is open to the internet
    (key-only login, no passwords). Restrict it to your own IP for anything long-lived,
    for example ["203.0.113.7/32"].
  EOT
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

########################################################################################
# Naming, placement, sizing
########################################################################################

variable "name_prefix" {
  description = "Prefix for every resource name."
  type        = string
  default     = "gltrain"
}

variable "location" {
  description = "Hetzner location. Server types are offered per location: check with 'hcloud server-type describe <type>'."
  type        = string
  default     = "nbg1"
}

variable "image" {
  description = "OS image for all VMs. The cloud-init files are written for and checked against Debian 13 (Podman 5.4, cloud-init 25.1). Other images may work but are untested."
  type        = string
  default     = "debian-13"
}

variable "gitlab_server_type" {
  description = "GitLab's single-node baseline is 8 vCPU and 16 GB RAM (cx43). cx33 (4 vCPU, 8 GB) works for a handful of users."
  type        = string
  default     = "cx43"
}

variable "runner_server_type" {
  description = "Runner VM. Docker-in-Docker builds plus scanners run in parallel: 8 GB (cx33) is comfortable, 4 GB is tight."
  type        = string
  default     = "cx33"
}

variable "deploy_server_type" {
  description = "Docker host that pipelines deploy to."
  type        = string
  default     = "cx23"
}

variable "enable_deploy_host" {
  description = "Create the third VM: a plain Docker host used as the deployment target in Day 2."
  type        = bool
  default     = true
}

variable "gitlab_swap_gb" {
  description = "Swap file size on the GitLab VM (a safety net, GitLab should not live in swap)."
  type        = number
  default     = 4
}

########################################################################################
# GitLab
########################################################################################

variable "gitlab_image" {
  description = "Container image. EE without a license behaves exactly like the free tier and lets you activate a trial for the training."
  type        = string
  default     = "docker.io/gitlab/gitlab-ee"
}

variable "gitlab_version" {
  description = "Image tag. Pin it. Upgrades must follow GitLab's required upgrade stops, so there is no automatic update."
  type        = string
  default     = "19.5.3-ee.0"
}

variable "gitlab_puma_workers" {
  description = "Puma worker processes. 2 suits 8 GB, use 4 or more on 16 GB."
  type        = number
  default     = 4
}

variable "gitlab_sidekiq_concurrency" {
  description = "Sidekiq threads. Lower it on small servers."
  type        = number
  default     = 20
}

########################################################################################
# DNS and TLS
########################################################################################

variable "base_domain" {
  description = <<-EOT
    Your domain for the instance, for example "training.example.com". GitLab becomes
    gitlab.<base_domain> and the Container Registry registry.<base_domain>.
    Leave empty to use a wildcard DNS name derived from the server IP
    (gitlab.<ip-with-dashes>.nip.io), which needs no DNS setup.
  EOT
  type        = string
  default     = ""
}

variable "dns_zone" {
  description = <<-EOT
    Name of a zone that already exists in Hetzner DNS (for example "example.com").
    When set, Terraform creates the gitlab.* and registry.* A records for you.
    base_domain must be this zone or a subdomain of it. Leave empty to create the
    records yourself (the outputs list them), or use cloudflare_zone instead.
  EOT
  type        = string
  default     = ""
}

variable "dns_ttl" {
  description = "TTL of the records created in dns_zone."
  type        = number
  default     = 300
}

variable "wildcard_dns_suffix" {
  description = "Wildcard DNS service used when base_domain is empty. Both nip.io and sslip.io resolve a-b-c-d.<suffix> to a.b.c.d."
  type        = string
  default     = "nip.io"
}

variable "acme_email" {
  description = "Contact address for Let's Encrypt (expiry notices). Optional."
  type        = string
  default     = ""
}

########################################################################################
# Runner
########################################################################################

variable "runner_concurrent" {
  description = "Jobs the runner VM executes in parallel."
  type        = number
  default     = 4
}

variable "runner_tags" {
  description = "Tags of the instance runner created for the training."
  type        = list(string)
  default     = ["docker", "linux"]
}

########################################################################################
# Deploy host
########################################################################################

variable "app_cidrs" {
  description = "Networks allowed to open the demo applications (ports 8080-8081) on the deploy host."
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "cloudflare_zone" {
  description = <<-EOT
    Name of a zone that already exists in Cloudflare (for example "example.com"). When set,
    Terraform creates the gitlab.* and registry.* A records there (DNS only, not proxied).
    base_domain must be this zone or a subdomain of it. Cannot be combined with dns_zone.
  EOT
  type        = string
  default     = ""
}

variable "cloudflare_api_token" {
  description = <<-EOT
    Cloudflare API token, only needed with cloudflare_zone. Create a token limited to that
    zone with the permissions Zone > Zone > Read and Zone > DNS > Edit. Not a zone ID, not
    the Global API Key. Put it in terraform.auto.tfvars (git-ignored) or TF_VAR_cloudflare_api_token.
  EOT
  type        = string
  default     = ""
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Optional. ID of the Cloudflare account that owns cloudflare_zone, to make the zone lookup unambiguous when the token can see several accounts. Not a secret, and not the API token."
  type        = string
  default     = ""
}

variable "admin_username" {
  description = <<-EOT
    User name of the first GitLab administrator. GitLab creates it as "root"; when this is different the bootstrap
    renames it, so the built-in "root" name does not exist on the instance. The password stays the generated one
    (terraform output -raw root_password).
  EOT
  type        = string
  default     = "root"

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.-]*$", var.admin_username)) && !endswith(var.admin_username, ".git")
    error_message = "admin_username may contain letters, digits, '_', '-' and '.', and must start with a letter or digit."
  }
}

variable "admin_email" {
  description = "E-mail address of the first administrator. Applied by the bootstrap without a confirmation mail (no mail server is configured). Empty leaves the address GitLab generated (gitlab_admin_<number>@example.com)."
  type        = string
  default     = ""

  validation {
    condition     = var.admin_email == "" || can(regex("^[^@\\s']+@[^@\\s']+$", var.admin_email))
    error_message = "admin_email must be empty or look like an e-mail address."
  }
}
