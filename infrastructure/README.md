# Training infrastructure (Hetzner Cloud)

A self-hosted GitLab for the training, so you are the administrator, plus a runner and a
Docker host for the CI/CD labs. Everything is configured by cloud-init: you run
`terraform apply` and wait.

| VM       | Default type    | What runs there                                                              |
| -------- | --------------- | ----------------------------------------------------------------------------- |
| `gitlab` | `cx43` (8 vCPU, 16 GB) | GitLab EE in a Podman container (Quadlet), Caddy for TLS and routing  |
| `runner` | `cx33` (4 vCPU, 8 GB)  | Docker Engine, GitLab Runner with the Docker executor                |
| `deploy` | `cx23` (2 vCPU, 4 GB)  | Docker Engine; the target pipelines deploy to over SSH (optional)     |

Running cost is a few cents per hour for all three with the `cx` types; if those are out of stock (see Troubleshooting) the `cpx` equivalents cost about 8 times that (roughly EUR 0.24 per hour in total). Destroy everything between sessions
if you like: `terraform destroy` removes the VMs and the addresses.

## What you need

- A Hetzner Cloud project and an API token with read and write access.
- Terraform 1.6 or newer (or OpenTofu), and an SSH key pair.
- Optional: a domain. Without one the instance is reachable as
  `gitlab.<ip-with-dashes>.nip.io`, which needs no DNS setup and still gets a trusted
  Let's Encrypt certificate.

## Start

Before the first apply, `../scripts/preflight.sh` checks the image, the server types in your location, name
collisions and your SSH key with a read-only call to the Hetzner API (with `cloudflare_zone` also the Cloudflare token, the zone and existing
records), and creates nothing.

```bash
cd infrastructure
cp terraform.tfvars.example terraform.tfvars   # set hcloud_token (and optionally the rest)
terraform init
terraform apply
```

Then wait. Roughly: servers are up after a minute, the GitLab image download takes a few
minutes, and **the first GitLab start takes 5-10 more**. The runner VM waits for GitLab by
itself and registers when it is ready. Follow along:

```bash
terraform output watch_progress          # ready-made commands
ssh -p 6022 root@<gitlab ip> podman logs -f gitlab
```

When `terraform output gitlab_url` answers in a browser, sign in as the administrator. GitLab seeds it as `root`; with
`admin_username` and `admin_email` set (see `variables.tf`) the bootstrap renames it, so no account called `root` exists:

```bash
terraform output gitlab_url
terraform output admin_username
terraform output -raw root_password        # the administrator's initial password, whatever its name
```

Change that password after the first sign-in (the generated one stays in `terraform.tfstate`
and in `/srv/gitlab/config/gitlab.rb` on the VM).

## Verify

`../scripts/smoke-test.sh` checks the sign-in page, the registry endpoint, the HTTP to HTTPS redirect,
Git over SSH on port 22, the moved host SSH port, that **you can log in** to each VM, and that the generated
deploy key logs in as `deploy` and can use Docker. With `GITLAB_TOKEN` set to an administrator's personal
access token it also checks that a runner is online, that sign-up is off, and that the example pipelines
pass CI Lint on the real server (a throwaway project is created and removed).

## How it fits together

```
 internet ──443/80──▶ Caddy (container) ──▶ GitLab (container, HTTP on :80)  GitLab web, API
                          │                                                   Git over HTTPS
                          └── registry.<domain> ──▶ GitLab :5050              Container Registry
 internet ──22──────▶ GitLab container (its own sshd)                         Git over SSH
 you ─────6022──────▶ the VM's own sshd                                       administration
```

- **Quadlet.** `gitlab.container`, `caddy.container` and `gitlab.network` live in
  `/etc/containers/systemd/` and become `gitlab.service`, `caddy.service` and
  `gitlab-network.service`. Use `systemctl status gitlab`, `journalctl -u gitlab`,
  `podman logs gitlab`. Containers start on boot.
- **SSH port.** The VM's sshd listens on `ssh_port` (6022), key-only. Port 22 is published
  by the GitLab container, so `git clone git@gitlab...:group/project.git` works with the
  default port. The same port move is applied to the runner and deploy VMs so you have one
  rule to remember.
- **TLS.** Caddy obtains and renews certificates. GitLab's own Let's Encrypt is disabled.
  Certificates live in the `caddy-data` volume.
- **Runner registration.** Terraform generates a one-time bootstrap token. The GitLab VM
  creates it as a short-lived personal access token of `root` with only the `read_user` and
  `create_runner` scopes. The runner VM waits until `GET /api/v4/user` succeeds with it,
  creates an *instance runner* through `POST /api/v4/user/runners`, registers with the
  resulting `glrt-` token, and revokes the bootstrap token. If anything goes wrong the token
  expires after two days on its own.
- **Deploy key.** Terraform generates an ED25519 key pair. The public half is installed for
  the `deploy` user on the deploy VM. The private half is for the CI/CD variable
  `SSH_PRIVATE_KEY` (Chapter 7, or `scripts/seed-training-data.sh`).

## Running a training on it

| When | What |
| ---- | ---- |
| T-14 days | Confirm dates, attendee count, language, **which tier the client has** and whether it is GitLab.com or self-managed. Send the participant prerequisites (README, Chapter 0) |
| T-5 days | Request the **Ultimate trial** (see below). It runs 30 days and the activation code works once |
| T-3 days | `scripts/preflight.sh`, `terraform apply`, wait 15 to 20 minutes, run `scripts/smoke-test.sh`. Activate the trial in *Admin > Subscription* |
| T-3 days | Create an administrator token (below), run `scripts/seed-training-data.sh` (set `TRAINEES=<attendees>`), print `training-accounts.txt` |
| T-2 days | **Rehearse every hands-on part** as a trainee and as the personas. Run one pipeline the evening before so the images are cached on the runner |
| Day 0 | Arrive early, run the smoke test again |
| After | Collect feedback. Ask before you `terraform destroy`: the servers cost money while they run |

**The administrator.** `admin_username` and `admin_email` (see `variables.tf`) rename GitLab's built-in `root`, so no account called `root` exists; the password is `terraform output -raw root_password`. Create an API token for yourself in *Edit profile > Access > Personal access tokens* (scope `api`, short expiry) and **change the password first**. GitLab 19.5 disables the OAuth password grant, so a token cannot be created by script from a password alone.

**Seeding.** `GITLAB_TOKEN=<token> scripts/seed-training-data.sh` creates the personas (`alice` Developer, `bob` Maintainer, `carol` Reporter, `dave` Guest), the trainees, the group `training` with `git-exercises` (without the solutions), `hello-app` and `ci-components` (tagged 1.0.0), and the instance-level CI/CD variables for the deploy pipeline. It is safe to run again and keeps the passwords already in `training-accounts.txt`, but it **skips a project that already has content**: after you edit files under `examples/`, delete `training/hello-app` and `training/ci-components` (mark for deletion, then delete permanently; a project with registry tags needs its tags removed first) and run it again.

```bash
podman logs -f gitlab                               # what GitLab is doing
podman exec gitlab gitlab-ctl status                # components
systemctl status gitlab caddy                       # Quadlet-managed services
```

**Things that bite on the day**

| Risk | What to do |
| ---- | ---------- |
| First pipeline is slow | Run one yourself the evening before: images are cached on the runner afterwards |
| Docker Hub rate limit (all jobs pull from one IP) | The runner uses `if-not-present`; log in on the runner VM or use the group Dependency Proxy |
| Scanner images come from `registry.gitlab.com` | The runner needs outbound access to it: check in the rehearsal |
| Port 22 blocked at the venue | HTTPS with a token works for everything in the hands-on parts; keep a mobile hotspot |
| Memory pressure with many parallel pipelines | `runner_concurrent` is 4; keep scanners to one or two participants at a time |
| Docker 29 attestations rejected by the registry | The example pipelines set `BUILDX_NO_DEFAULT_ATTESTATIONS=1`; participants pushing from a laptop may need it too |
| Trial not active | Premium and Ultimate steps become demos from the trainer's screen; none blocks the rest of a hands-on part |
| Windows without Git Bash | The Git scenarios will not run: use WSL or ready-made repositories |
| After Chapter 4 every merge needs bob | Chapter 4, step 8 has the participants relax the gate. Check at the start of Chapter 6 |

## Getting a licence for the Premium and Ultimate features

The image is GitLab EE. **Without a licence it behaves exactly like the free edition** and
works fine for the CI/CD parts. Several Day 1 topics (code owners, push rules, approval
rules, protected environments, the vulnerability report, security policies, custom roles)
need Premium or Ultimate to be tried hands-on. For the training:

1. At least a few days before Day 1, request a self-managed **Ultimate trial** at
   <https://about.gitlab.com/free-trial/?hosted=self-managed>. It is valid for 30 days.
2. The activation code is emailed and works **once**.
3. In GitLab: *Admin > Subscription*, paste the code, accept the terms, activate.

Start the 30 days no earlier than a few days before the training. Without the trial, the
labs still run; the steps marked Premium or Ultimate become demonstrations from the trainer's
screen or from the documentation.

## Using your own domain

```hcl
base_domain = "training.example.com"      # gitlab.training.example.com, registry.training.example.com
```

Create the two A records that `terraform output dns_records_to_create` prints, pointing at
the GitLab address, as soon as `apply` has finished. Caddy retries failed certificate requests
with growing delays; if it has not picked the records up after a few minutes, run
`systemctl restart caddy` on the GitLab VM to trigger a fresh attempt.

If the zone is in Hetzner DNS, let Terraform do it:

```hcl
base_domain = "training.example.com"
dns_zone    = "example.com"
```

If the zone is in Cloudflare, Terraform can create the records there (use `cloudflare_zone` **or** `dns_zone`, not both):

```hcl
base_domain          = "example.com"          # gitlab.example.com, registry.example.com
cloudflare_zone      = "example.com"
cloudflare_api_token = "..."                  # in terraform.auto.tfvars (git-ignored), never in a file you commit
```

The token is an **API token** (My Profile > API Tokens), limited to that zone, with *Zone > Zone > Read* and
*Zone > DNS > Edit*. A zone ID or account ID (32 hex characters) is not a token; `scripts/preflight.sh` says so. The records are
created **DNS only** (`proxied = false`) and must stay so: the Cloudflare proxy does not carry Git over SSH on port 22, limits
request bodies (registry pushes fail), and gets in the way of Caddy's certificate validation. Cloudflare happily keeps two
A records with the same name, so `preflight.sh` refuses to continue when `gitlab.<base_domain>` or `registry.<base_domain>`
already exists. If the domain has CAA records, they must allow `letsencrypt.org`.

## Operating notes

- **Changing a cloud-init file and re-applying does not rebuild servers.** `user_data` is
  deliberately ignored after creation, because replacing the GitLab VM destroys its data. To
  re-provision on purpose: `terraform apply -replace=hcloud_server.gitlab`.
- **Upgrades.** The GitLab image tag is pinned (`gitlab_version`). GitLab requires upgrading
  through specific versions; do not jump freely. Change the tag, then
  `systemctl restart gitlab` after `podman pull`. There is intentionally no auto-update.
- **Backups.** `podman exec gitlab gitlab-backup create` writes to `/srv/gitlab/data/backups/`;
  `podman exec gitlab gitlab-ctl backup-etc` writes `gitlab.rb`, `gitlab-secrets.json` and the SSH host
  keys to `/srv/gitlab/config/config_backup/`. The first does **not** contain the second. Copy both
  off the VM. The registry runs on its metadata database, and the first archive holds the registry
  files but **no dump of that database** (no backup credentials are set): see Chapter 10 of the
  main README, and add a `pg_dump` of the `registry` database until you have tested the credentials.
- **Lock down SSH** for anything long-lived: `admin_cidrs = ["<your ip>/32"]`.
- **Memory.** `cx43` matches GitLab's single-node baseline. On `cx33` (8 GB) lower
  `gitlab_puma_workers` to 2 and `gitlab_sidekiq_concurrency` to 10.
- **Outbound mail** is not configured, so GitLab sends no email. Accounts are created by
  the trainer with known passwords. Port 25 is blocked on Hetzner Cloud in any case.

## Troubleshooting

| Symptom                                   | Look at                                                                                  |
| ----------------------------------------- | ---------------------------------------------------------------------------------------- |
| `https://gitlab...` does not answer       | `podman logs caddy` (certificate problems, DNS); `curl -I http://<ip>` should redirect   |
| Caddy cannot get a certificate            | DNS record missing, or port 80 blocked: Let's Encrypt validates over port 80/443         |
| 502 from Caddy                            | GitLab is still starting: `podman logs -f gitlab`, `podman healthcheck run gitlab`       |
| No runner appears                         | On the runner VM: `journalctl -u training-runner-bootstrap`                              |
| `Permission denied (publickey)` on 6022   | The key in `ssh_public_key_file` is not the one your agent offers; `ssh -i ... -p 6022`  |
| Git over SSH asks for a password          | Add your key under *User settings > SSH Keys*; use `git@<gitlab host>` on port 22         |
| Bootstrap never finishes: sign-up open, no runner | On the GitLab VM: `journalctl -u training-gitlab-bootstrap`. `ls -l /srv/gitlab/config/bootstrap.rb` must be `-rw-r--r--` (the Rails runner runs as `git`) |
| `docker push` ends with `blob unknown to registry` | Docker 29 adds attestation manifests that the GitLab 19.5 registry rejected. Build with `BUILDX_NO_DEFAULT_ATTESTATIONS=1` (the example pipelines set it) |
| Deploy job: `Load key ... error in libcrypto`, then `Permission denied (publickey)` | The `SSH_PRIVATE_KEY` File variable has no trailing newline. `scripts/seed-training-data.sh` adds it; in the UI, end the value with a newline |
| `Hetzner: 409 uniqueness_error` (SSH key) | The key is already in the project under another name: set `existing_ssh_key_name`. `preflight.sh` tells you |
| `Hetzner: resource_unavailable (error during placement)` | That server type is out of stock right now: pick another type; `preflight.sh` shows what is in stock |
| Let's Encrypt rate limit with nip.io      | Set `base_domain`, or `wildcard_dns_suffix = "sslip.io"`; Caddy also falls back to ZeroSSL |

## What was and was not tested

The course material makes many claims about GitLab. This is what was verified, how, and what is still unverified. Read it before you teach.

### Run on a live instance (2026-11-09: Hetzner nbg1, Cloudflare DNS, GitLab 19.5.3 EE **without a licence**)

| Area | Result |
| ---- | ------ |
| `terraform apply` | Three servers, DNS-only records in Cloudflare, a Let's Encrypt certificate through Caddy. `scripts/smoke-test.sh` passed **24 of 24** (HTTPS, registry `401`, Git on 22, host SSH on 6022, key-only login to all VMs, the deploy key and Docker, a runner online, sign-up off, 9 example pipelines linted on the server) |
| Zero-touch chain | Bootstrap token created, the runner VM registered an instance runner by itself, the bootstrap token was revoked, the administrator was renamed to the configured name and e-mail |
| What failed on the way | (1) Hetzner refused an SSH key already in the project: `existing_ssh_key_name`. (2) The `cx` types were **out of stock in every EU location** (`resource_unavailable`): `preflight.sh` now checks live capacity; the test used `cpx42/cpx32/cpx22`, about 8 times the hourly price. (3) On the first build the bootstrap never ran (sign-up stayed open, no runner): `bootstrap.rb` was root-only `0600` and `gitlab-rails runner` runs as the `git` user. Fixed with `0644`; the second build bootstrapped at the first attempt. The cause rests on the GitLab docs, the symptoms and a successful rebuild, not on a controlled test |
| Seed script | Run on the instance several times (idempotent). Found and fixed: `[ci skip]` in the components commit made the **1.0.0 tag pipeline skip**, so no release; the SSH key in the File variable lost its trailing newline (`Load key: error in libcrypto`); a re-run overwrote the passwords in `training-accounts.txt` |
| Chapter 7 build and deploy, end to end (in a fork) | `lint`, `unit-tests`, `build-image` (dind), push to the registry, `deploy-dev` over SSH, the manual `deploy-prod`: dev and production answered with the **same commit SHA**. **Found:** Docker 29 adds attestation manifests and the 19.5 registry (v4.42.0, metadata database mode) answered `blob unknown to registry`. Controlled test: the same project with `BUILDX_NO_DEFAULT_ATTESTATIONS=1` pushed fine; an unchanged pipeline in a namespace without a dot failed, so the cause is the attestations, not the dotted user name. All three build examples set it. A laptop with a recent Docker may behave the same: not tested |
| Component release | `training/ci-components` 1.0.0: `yamllint` and `create-release` ran on the runner and the release exists. *Using* the component in a pipeline (Chapter 7, part 2) was not run live |

### Checked offline

| Area | How |
| ---- | --- |
| Tier reference | The `Tier:` line (page and sections) of about 150 pages of the raw `19-5-stable-ee` documentation, read page by page, plus the licensed-feature lists in the product source. Project and group access token pages state **no tier**, so none is claimed |
| Governance claims (Chapter 9) | Read from the raw 19.5 pages (settings, approvals cascade, policies, compliance frameworks, audit event types, SCIM, tokens). **Read, not executed**: the instance has no licence |
| Git practice scenarios | `examples/git-exercises/verify-all.sh`: each scenario built and solved, also under a hostile global configuration (`core.autocrlf=true`, `merge.ff=only`, `pull.rebase=true`); the guard against deleting a foreign folder; `shellcheck` clean |
| Example pipelines | `scripts/check-ci-examples.sh` against GitLab's CI JSON schema (all pass), and CI Lint on the live server for the single-file ones. The gate scripts were run against synthetic reports (block, pass, empty, missing) |
| README | At the time of writing: every external link answered `200` (155), every internal anchor and file path existed, and 49 tier markers matched the `Tier:` line of the raw docs page linked beside them. These checks were throwaway scripts and are **not kept**: before you teach, re-run a link checker (for example `lychee README.md`) and re-read the `Tier:` line of any feature you are about to promise |

### Not checked: rehearse these

| Area | Why it matters |
| ---- | -------------- |
| **Premium and Ultimate behaviour** | The lab instance had no licence: approvals, code owners, push rules, protected environments, the vulnerability report, policies, compliance and audit features are **documentation-checked only**. Activate the Ultimate trial and rehearse |
| Hands-on of Chapters 3, 4 and 8, and the changed wording of Chapters 5 to 7, with real people | Written from the documentation and partly tested through the API |
| Behaviours where the documentation is ambiguous | (1) direct push by an allowed pusher with code owner approval enabled; (2) groups as code owners (the eligibility table and the 18.6/18.8 text differ); (3) entries with no resolvable owner; (4) which events actually appear in the project audit events; (5) what happens to a blocked user's tokens and SSH keys |
| Chapter 7: rollback (3.4) and protected environments (3.6) | The environments page and the play button were run; the rollback button and approvals were not |
| `step8-security-gate.yml` and `step8-scan-built-image.yml` with GitLab in the loop | The gate fetches the reports with `needs: artifacts: true` (reports have `access: developer`); not run. The scan-built-image example was only schema-checked |
| Pushing an image from a participant's laptop | Pushed from CI only |
| `terraform destroy`, upgrading GitLab, arm64 | Not tried |
| SOC 2 content | Paraphrased from general knowledge of the Trust Services Criteria; the AICPA text was not available. Have someone who works with auditors read it before you teach it as more than orientation |
| Timing | How long the hands-on parts take with real people |

## Quality checks

Run these from the repository root after you change anything (they need no Hetzner account):

```bash
shellcheck infrastructure/files/*/*.sh scripts/*.sh                         # all scripts
shellcheck -x -P SCRIPTDIR examples/git-exercises/*.sh examples/git-exercises/solutions/*.sh
examples/git-exercises/verify-all.sh                                        # every Git scenario builds and is solvable
scripts/check-ci-examples.sh                                                # every example pipeline against GitLab's CI JSON schema
python3 infrastructure/tests/render-cloud-init.py /tmp/rendered             # render cloud-init offline (checks the 32 KiB limit)
cd infrastructure && terraform init -backend=false && terraform validate    # then: terraform fmt -check
```

On a running instance `scripts/smoke-test.sh` (with `GITLAB_TOKEN`) also lints the example pipelines with CI Lint. `scripts/preflight.sh` is read-only and creates nothing.

## Tests that need no Hetzner account

```bash
python3 tests/render-cloud-init.py /tmp/rendered     # renders all three user_data files
```

The renderer reuses the real `locals` of `main.tf`. Run `cloud-init schema -c <file>` on the
results and check each `user_data` stays below Hetzner's 32 KiB limit (the Terraform
preconditions enforce the limit on every real `plan`).
