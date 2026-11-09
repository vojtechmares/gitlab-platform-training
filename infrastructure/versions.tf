terraform {
  required_version = ">= 1.6.0"

  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      # 1.67 removed the deprecated "datacenter" argument; this config uses "location".
      version = "~> 1.67"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      # v5 renamed the DNS resources (cloudflare_dns_record) and arguments compared to v4.
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

# Only used when cloudflare_zone is set; with it empty no Cloudflare resource exists.
provider "cloudflare" {
  api_token = var.cloudflare_api_token != "" ? var.cloudflare_api_token : null
}
