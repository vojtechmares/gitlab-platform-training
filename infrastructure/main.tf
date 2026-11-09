########################################################################################
# Naming, hostnames, secrets
########################################################################################

locals {
  admin_ssh_key_id = var.existing_ssh_key_name != "" ? data.hcloud_ssh_key.existing[0].id : hcloud_ssh_key.admin[0].id
  labels = {
    project    = "gitlab-platform-training"
    managed-by = "terraform"
  }

  # Primary IPs exist before the servers, so every hostname is known when
  # cloud-init is rendered (no cycle between server and user_data).
  gitlab_ip  = hcloud_primary_ip.gitlab.ip_address
  runner_ip  = hcloud_primary_ip.runner.ip_address
  deploy_ip  = var.enable_deploy_host ? hcloud_primary_ip.deploy[0].ip_address : ""
  dashed_ip  = replace(local.gitlab_ip, ".", "-")
  use_domain = var.base_domain != ""

  gitlab_fqdn   = local.use_domain ? "gitlab.${var.base_domain}" : "gitlab.${local.dashed_ip}.${var.wildcard_dns_suffix}"
  registry_fqdn = local.use_domain ? "registry.${var.base_domain}" : "registry.${local.dashed_ip}.${var.wildcard_dns_suffix}"
  gitlab_url    = "https://${local.gitlab_fqdn}"

  # Same value the runner VM will present and the GitLab VM will create (see
  # files/gitlab/bootstrap.rb). Revoked by the runner VM once the runner exists.
  bootstrap_token = random_password.bootstrap_token.result
}

# GitLab refuses to create the admin account when its password validator finds "commonly
# used combinations of words and letters", and then starts with no root user at all.
# Long, with every character class, makes that practically impossible. The special
# characters are limited to ones that are safe in gitlab.rb (single-quoted Ruby string),
# in shell, and when typed into a form.
resource "random_password" "root" {
  length           = 32
  special          = true
  override_special = "-_.+=@"
  min_upper        = 4
  min_lower        = 4
  min_numeric      = 4
  min_special      = 2
}

# GitLab accepts a personal access token string of exactly 20 characters when it is set
# programmatically. Alphanumeric only, so it is safe in shell and in HTTP headers.
resource "random_password" "bootstrap_token" {
  length  = 20
  special = false
}

# Key pair the pipelines use to deploy (CI variable SSH_PRIVATE_KEY, see Chapter 7).
resource "tls_private_key" "deploy" {
  algorithm = "ED25519"
}

# Hetzner refuses to upload a public key that is already in the project (409 uniqueness_error), whatever its name.
# In that case set existing_ssh_key_name and the key is looked up instead of created.
resource "hcloud_ssh_key" "admin" {
  count = var.existing_ssh_key_name == "" ? 1 : 0

  name       = "${var.name_prefix}-admin"
  public_key = file(pathexpand(var.ssh_public_key_file))
  labels     = local.labels
}

data "hcloud_ssh_key" "existing" {
  count = var.existing_ssh_key_name != "" ? 1 : 0

  name = var.existing_ssh_key_name
}

########################################################################################
# Stable public addresses
########################################################################################

resource "hcloud_primary_ip" "gitlab" {
  name        = "${var.name_prefix}-gitlab-v4"
  type        = "ipv4"
  location    = var.location
  auto_delete = false
  labels      = local.labels
}

resource "hcloud_primary_ip" "runner" {
  name        = "${var.name_prefix}-runner-v4"
  type        = "ipv4"
  location    = var.location
  auto_delete = false
  labels      = local.labels
}

resource "hcloud_primary_ip" "deploy" {
  count       = var.enable_deploy_host ? 1 : 0
  name        = "${var.name_prefix}-deploy-v4"
  type        = "ipv4"
  location    = var.location
  auto_delete = false
  labels      = local.labels
}

########################################################################################
# Firewalls (attached through firewall_ids, so they apply from the first boot)
########################################################################################

resource "hcloud_firewall" "gitlab" {
  name   = "${var.name_prefix}-gitlab"
  labels = local.labels

  rule {
    description = "Host SSH (moved off port 22)"
    direction   = "in"
    protocol    = "tcp"
    port        = tostring(var.ssh_port)
    source_ips  = var.admin_cidrs
  }
  rule {
    description = "Git over SSH (GitLab container)"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
  rule {
    description = "HTTP (ACME challenge and redirect to HTTPS)"
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
  rule {
    description = "HTTPS (GitLab and Container Registry)"
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
  rule {
    description = "HTTP/3"
    direction   = "in"
    protocol    = "udp"
    port        = "443"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
  rule {
    description = "Ping"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_firewall" "runner" {
  name   = "${var.name_prefix}-runner"
  labels = local.labels

  rule {
    description = "Host SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = tostring(var.ssh_port)
    source_ips  = var.admin_cidrs
  }
  rule {
    description = "Ping"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_firewall" "deploy" {
  count  = var.enable_deploy_host ? 1 : 0
  name   = "${var.name_prefix}-deploy"
  labels = local.labels

  rule {
    description = "Host SSH from the admin and from the runner (pipelines deploy over SSH)"
    direction   = "in"
    protocol    = "tcp"
    port        = tostring(var.ssh_port)
    source_ips  = concat(var.admin_cidrs, ["${local.runner_ip}/32"])
  }
  rule {
    description = "Demo applications: dev 8081, production 8080"
    direction   = "in"
    protocol    = "tcp"
    port        = "8080-8081"
    source_ips  = var.app_cidrs
  }
  rule {
    description = "Ping"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
}

########################################################################################
# Cloud-init
########################################################################################

locals {
  # Files shared as-is by the cloud-init templates. They are plain scripts (not
  # templates) so shellcheck can lint them; settings reach them through /etc/training/env.
  script_move_sshd      = file("${path.module}/files/common/move-sshd.sh")
  script_install_docker = file("${path.module}/files/common/install-docker.sh")

  gitlab_rb = templatefile("${path.module}/files/gitlab/gitlab.rb.tftpl", {
    gitlab_fqdn         = local.gitlab_fqdn
    registry_fqdn       = local.registry_fqdn
    root_password       = random_password.root.result
    puma_workers        = var.gitlab_puma_workers
    sidekiq_concurrency = var.gitlab_sidekiq_concurrency
  })

  gitlab_container = templatefile("${path.module}/files/gitlab/gitlab.container.tftpl", {
    image       = "${var.gitlab_image}:${var.gitlab_version}"
    gitlab_fqdn = local.gitlab_fqdn
  })

  caddyfile = templatefile("${path.module}/files/gitlab/Caddyfile.tftpl", {
    gitlab_fqdn   = local.gitlab_fqdn
    registry_fqdn = local.registry_fqdn
    acme_email    = var.acme_email
  })

  gitlab_user_data = templatefile("${path.module}/cloud-init/gitlab.yaml.tftpl", {
    ssh_port         = var.ssh_port
    swap_gb          = var.gitlab_swap_gb
    gitlab_fqdn      = local.gitlab_fqdn
    bootstrap_token  = local.bootstrap_token
    admin_username   = var.admin_username
    admin_email      = var.admin_email
    gitlab_rb        = local.gitlab_rb
    gitlab_container = local.gitlab_container
    caddyfile        = local.caddyfile
    script_move_sshd = local.script_move_sshd
    script_provision = file("${path.module}/files/gitlab/provision.sh")
    script_bootstrap = file("${path.module}/files/gitlab/bootstrap.sh")
    bootstrap_rb     = file("${path.module}/files/gitlab/bootstrap.rb")
    gitlab_image     = "${var.gitlab_image}:${var.gitlab_version}"
  })

  runner_user_data = templatefile("${path.module}/cloud-init/runner.yaml.tftpl", {
    ssh_port              = var.ssh_port
    gitlab_url            = local.gitlab_url
    bootstrap_token       = local.bootstrap_token
    runner_concurrent     = var.runner_concurrent
    runner_tags           = join(",", var.runner_tags)
    runner_name           = "${var.name_prefix}-runner"
    script_move_sshd      = local.script_move_sshd
    script_install_docker = local.script_install_docker
    script_provision      = file("${path.module}/files/runner/provision.sh")
    script_bootstrap      = file("${path.module}/files/runner/bootstrap.sh")
  })

  deploy_user_data = var.enable_deploy_host ? templatefile("${path.module}/cloud-init/deploy.yaml.tftpl", {
    ssh_port              = var.ssh_port
    deploy_public_key     = trimspace(tls_private_key.deploy.public_key_openssh)
    script_move_sshd      = local.script_move_sshd
    script_install_docker = local.script_install_docker
    script_provision      = file("${path.module}/files/deploy/provision.sh")
  }) : ""
}

########################################################################################
# Servers
########################################################################################

resource "hcloud_server" "gitlab" {
  name         = "${var.name_prefix}-gitlab"
  server_type  = var.gitlab_server_type
  image        = var.image
  location     = var.location
  ssh_keys     = [local.admin_ssh_key_id]
  firewall_ids = [hcloud_firewall.gitlab.id]
  user_data    = local.gitlab_user_data
  labels       = merge(local.labels, { role = "gitlab" })

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.gitlab.id
    ipv6_enabled = true
  }

  lifecycle {
    # Re-applying after editing a cloud-init file must never rebuild the server that holds
    # all the GitLab data. To re-provision on purpose: terraform apply -replace=hcloud_server.gitlab
    ignore_changes = [user_data, ssh_keys, image]

    precondition {
      condition     = length(local.gitlab_user_data) < 32768
      error_message = "The rendered GitLab user_data exceeds Hetzner's 32 KiB limit."
    }
  }
}

resource "hcloud_server" "runner" {
  name         = "${var.name_prefix}-runner"
  server_type  = var.runner_server_type
  image        = var.image
  location     = var.location
  ssh_keys     = [local.admin_ssh_key_id]
  firewall_ids = [hcloud_firewall.runner.id]
  user_data    = local.runner_user_data
  labels       = merge(local.labels, { role = "runner" })

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.runner.id
    ipv6_enabled = true
  }

  lifecycle {
    ignore_changes = [user_data, ssh_keys, image]

    precondition {
      condition     = length(local.runner_user_data) < 32768
      error_message = "The rendered runner user_data exceeds Hetzner's 32 KiB limit."
    }
  }
}

resource "hcloud_server" "deploy" {
  count        = var.enable_deploy_host ? 1 : 0
  name         = "${var.name_prefix}-deploy"
  server_type  = var.deploy_server_type
  image        = var.image
  location     = var.location
  ssh_keys     = [local.admin_ssh_key_id]
  firewall_ids = [hcloud_firewall.deploy[0].id]
  user_data    = local.deploy_user_data
  labels       = merge(local.labels, { role = "deploy" })

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.deploy[0].id
    ipv6_enabled = true
  }

  lifecycle {
    ignore_changes = [user_data, ssh_keys, image]
  }
}

########################################################################################
# DNS records in Hetzner DNS (optional)
########################################################################################

resource "hcloud_zone_rrset" "gitlab" {
  count = var.dns_zone != "" ? 1 : 0

  zone = var.dns_zone
  name = trimsuffix(local.gitlab_fqdn, ".${var.dns_zone}")
  type = "A"
  ttl  = var.dns_ttl

  records = [{ value = local.gitlab_ip }]

  lifecycle {
    precondition {
      condition     = local.use_domain && endswith(var.base_domain, var.dns_zone)
      error_message = "dns_zone requires base_domain, and base_domain must be the zone itself or a subdomain of it."
    }
  }
}

resource "hcloud_zone_rrset" "registry" {
  count = var.dns_zone != "" ? 1 : 0

  zone = var.dns_zone
  name = trimsuffix(local.registry_fqdn, ".${var.dns_zone}")
  type = "A"
  ttl  = var.dns_ttl

  records = [{ value = local.gitlab_ip }]
}

########################################################################################
# DNS records in Cloudflare (optional)
########################################################################################

data "cloudflare_zone" "this" {
  count = var.cloudflare_zone != "" ? 1 : 0

  filter = {
    name = var.cloudflare_zone
    # Optional: pins the lookup to one account when the token can see several.
    account = var.cloudflare_account_id != "" ? { id = var.cloudflare_account_id } : null
  }
}

resource "cloudflare_dns_record" "gitlab" {
  count = var.cloudflare_zone != "" ? 1 : 0

  zone_id = data.cloudflare_zone.this[0].zone_id
  name    = local.gitlab_fqdn
  type    = "A"
  content = local.gitlab_ip
  ttl     = var.dns_ttl
  # Must stay DNS only. The Cloudflare proxy does not carry Git over SSH on port 22, limits request
  # bodies (registry pushes would fail), and sits in front of Caddy's certificate validation.
  proxied = false
  comment = "GitLab training (Terraform)"

  lifecycle {
    precondition {
      condition     = local.use_domain && endswith(local.gitlab_fqdn, ".${var.cloudflare_zone}")
      error_message = "cloudflare_zone requires base_domain, and base_domain must be the zone itself or a subdomain of it."
    }
    precondition {
      condition     = var.dns_zone == ""
      error_message = "Use either cloudflare_zone or dns_zone (Hetzner DNS), not both."
    }
    precondition {
      condition     = var.cloudflare_api_token != ""
      error_message = "cloudflare_zone needs cloudflare_api_token (an API token with Zone > Zone > Read and Zone > DNS > Edit, not a zone ID)."
    }
  }
}

resource "cloudflare_dns_record" "registry" {
  count = var.cloudflare_zone != "" ? 1 : 0

  zone_id = data.cloudflare_zone.this[0].zone_id
  name    = local.registry_fqdn
  type    = "A"
  content = local.gitlab_ip
  ttl     = var.dns_ttl
  proxied = false # see the note on the gitlab record
  comment = "GitLab training (Terraform)"
}
