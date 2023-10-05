# terraform_upgrade_kit

Terraform is great. It works...

...and sometimes, that's the problem.

---

This repo is for anyone who has neglected to upgrade their Terraform and provider plugin versions. In the case of TF 0.11.X, they've never provided ARM64 compatibility, meaning ARM-based Mac's are out of luck.

To which you might say, "containerize it, then!"

...except 0.11.X won't even run with x86 emulation MacOS 12.X Monterey+

## Requirements

- Docker desktop

## Repo Structure

- `/`       - Common scripts used to build and run various Terraform versions within a Docker container
- `/0.13/`  - Fixtures and scripts for `0.11.X` -> `0.13.8` upgrade

## Configuration Parameters and Defaults

- `REGION ?= us-west-2`
  - Cloud region (applicable to AWS, others)

- `TFVARS_FILE ?= staging.tfvars`
  - Path to `tfvars` file

- `TERRAFORM_SOURCES ?= $(HOME)/git/ztrack-consumers/provisioning/terraform`
  - Path to `tf` file(s), mounted as writable under `./<VERSION_FOLDER>/tfsrc`

- `ADD_VOLUMES ?= -v $(HOME)/.aws:/root/.aws`
  - Additional local:container volumes to be mounted. Additional volumes can be appended e.g. ` -v foo:bar`

- `SSH_KEY ?= $(HOME)/.ssh/id_rsa`
  - Path to local key used by SSH, if needed (i.e. for cloning private Github repos)
