# Acme CI/CD components

Reusable pipeline building blocks used in Chapter 7.

| Component       | What it adds                                          |
| --------------- | ----------------------------------------------------- |
| `python-checks` | `lint` and `unit-tests` jobs with pip cache and JUnit |
| `docker-build`  | Builds an image with Docker-in-Docker and pushes it   |

## Usage

```yaml
include:
  - component: $CI_SERVER_FQDN/acme/platform/ci-components/python-checks@1.0.0
    inputs:
      python_version: "3.13"
  - component: $CI_SERVER_FQDN/acme/platform/ci-components/docker-build@1.0.0
```

The version after `@` can be a release tag, a branch, a commit SHA or `~latest`.
Pin a tag in production pipelines and update it deliberately.

## Releasing

Push a tag such as `1.0.0`. The pipeline creates the release. Marking the project as a
CI/CD Catalog resource (Settings > General > Visibility > CI/CD Catalog resource) lists the
components in the catalog; including them by path works without it.

## Rules for components in this repository

- One component per file in `templates/`, named after what it does.
- Every input has a `description` and a sensible `default`.
- Hidden jobs (leading dot) hold shared settings; real jobs have stable names.
