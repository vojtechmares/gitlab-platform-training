#!/usr/bin/env python3
"""Render the three cloud-init files offline, without a Hetzner account.

It reuses the real `locals` blocks of main.tf (so the template arguments are exactly
the production ones) and replaces only the cloud resources with fake values.

    python3 tests/render-cloud-init.py OUT_DIR [key=value ...]

Writes gitlab.yaml, runner.yaml, deploy.yaml and the intermediate gitlab.rb, Caddyfile and
gitlab.container into OUT_DIR. Extra key=value arguments override variables, for example
base_domain=training.example.com.
"""

import pathlib
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = pathlib.Path(__file__).resolve().parents[1]

FAKES = {
    "hcloud_primary_ip.gitlab.ip_address": '"203.0.113.10"',
    "hcloud_primary_ip.runner.ip_address": '"203.0.113.11"',
    "hcloud_primary_ip.deploy[0].ip_address": '"203.0.113.12"',
    "data.hcloud_ssh_key.existing[0].id": '"1"',
    "hcloud_ssh_key.admin[0].id": '"2"',
    "random_password.root.result": '"Qv8-kD3_mW7+xN2.rT5@hB9yS4Lp"',
    "random_password.bootstrap_token.result": '"fakeBootstrapTok20ab"',
    "tls_private_key.deploy.public_key_openssh": '"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFAKEKEYFORRENDERINGONLY0000000000000 deploy"',
}


def extract_blocks(text: str, header: str) -> list[str]:
    """Return every top-level `header { ... }` block, matching braces."""
    blocks = []
    for match in re.finditer(rf"^{re.escape(header)}\s*\{{", text, re.M):
        depth, i = 0, match.end() - 1
        while True:
            depth += text[i] == "{"
            depth -= text[i] == "}"
            i += 1
            if depth == 0:
                break
        blocks.append(text[match.start() : i])
    return blocks


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    out = pathlib.Path(sys.argv[1]).resolve()
    overrides = dict(arg.split("=", 1) for arg in sys.argv[2:])
    out.mkdir(parents=True, exist_ok=True)

    main_tf = (ROOT / "main.tf").read_text()
    locals_blocks = "\n\n".join(extract_blocks(main_tf, "locals"))
    for real, fake in FAKES.items():
        locals_blocks = locals_blocks.replace(real, fake)

    variables = (ROOT / "variables.tf").read_text()
    variables = variables.replace(
        'variable "hcloud_token" {', 'variable "hcloud_token" {\n  default = "unused"', 1
    )
    for name, value in overrides.items():
        variables = re.sub(
            rf'(variable "{name}" \{{.*?default\s*=\s*)[^\n]+',
            rf'\g<1>"{value}"',
            variables,
            count=1,
            flags=re.S,
        )

    outputs = "\n".join(
        f'output "{n}" {{ value = local.{n} }}'
        for n in ("gitlab_user_data", "runner_user_data", "deploy_user_data",
                  "gitlab_rb", "caddyfile", "gitlab_container")
    )

    with tempfile.TemporaryDirectory() as tmp:
        work = pathlib.Path(tmp)
        for sub in ("files", "cloud-init"):
            shutil.copytree(ROOT / sub, work / sub)
        (work / "main.tf").write_text(
            "terraform {}\n\n" + variables + "\n\n" + locals_blocks + "\n\n" + outputs + "\n"
        )
        for cmd in (["terraform", "apply", "-auto-approve", "-no-color", "-input=false"],):
            result = subprocess.run(cmd, cwd=work, capture_output=True, text=True)
            if result.returncode != 0:
                sys.stderr.write(result.stdout + result.stderr)
                return result.returncode
        names = {
            "gitlab_user_data": "gitlab.yaml",
            "runner_user_data": "runner.yaml",
            "deploy_user_data": "deploy.yaml",
            "gitlab_rb": "gitlab.rb",
            "caddyfile": "Caddyfile",
            "gitlab_container": "gitlab.container",
        }
        for output, filename in names.items():
            raw = subprocess.run(
                ["terraform", "output", "-raw", output], cwd=work, capture_output=True, text=True, check=True
            ).stdout
            (out / filename).write_text(raw)
            print(f"{filename:18} {len(raw.encode()):6} bytes")
    return 0


if __name__ == "__main__":
    sys.exit(main())
