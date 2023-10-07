# terraform_upgrade_kit

Terraform is great. It works...

...and sometimes, that's the problem.

---

This repo is for anyone who has neglected to upgrade their Terraform and provider plugin versions. In the case of TF 0.11.X, they've never provided ARM64 compatibility, meaning ARM-based Mac's are out of luck.

Containerization is a great workaround, and has, in our case, helped us maintain version freezes for many years (0.11 is 5 years old at the time of this writing).  However, older versions don't work, even in a container, and even under emulation, on newer MacOS versions.

So, follow along below to get your Terraform states updated, major version by major version, to the newest and shiniest Terraform yet.

## Requirements

- Docker desktop

## Repo Structure

- [`0.13/`](0.13/)   - Fixtures and scripts for `0.11.X` -> `0.13.8` upgrade
- [`1.5.7/`](1.5.7/) - Containerized Terraform drop-in scripts for pinning versions (can also be used with DinD for CI/CD scenarios)

## Configuration Parameters and Defaults

These variables can be passed in during Terraform execution, e.g.:
`REGION=us-west-2 TFVARS_PATH=foo.tfvars make init`

- `ENVIRONMENT ?= staging`
  - The Terraform `env` value

- `REGION ?= us-west-2`
  - Cloud region (applicable to AWS, others)

- `TERRAFORM_SOURCES ?= $(HOME)/git/ztrack-consumers/provisioning/terraform`
  - Path to local `tf` file(s), mounted as writable under `./<VERSION_FOLDER>/tfsrc`

- `TFVARS_PATH ?= staging.tfvars`
  - Path to `tfvars` file, most likely mounted in the container under `tfsrc`

- `ADD_VOLUMES ?= -v $(HOME)/.aws:/root/.aws`
  - Additional local:container volumes to be mounted. Additional volumes can be appended e.g. ` -v foo:bar`

- `SSH_KEY ?= $(HOME)/.ssh/id_rsa`
  - Path to local key used by SSH, if needed (i.e. for cloning private Github repos)
