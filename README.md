# terraform_upgrade_kit

Terraform is great. It works... and sometimes, that's the problem.

---

This repo is for anyone who has neglected to upgrade their Terraform and provider plugin versions. In the case of TF 0.11.X, they've never provided ARM64 compatibility, meaning ARM-based Mac's are out of luck.

Containerization is a great workaround, and has, in our case, helped us maintain version freezes for many years (0.11 is 5 years old at the time of this writing).  However, older versions don't work, even in a container, and even under emulation, on newer MacOS versions.

So, follow along below to get your Terraform states updated, major version by major version, to the newest and shiniest Terraform yet.

## Requirements

- Docker desktop

## Repo Structure

- [`0.13/`](0.13/)   - Fixtures and scripts for `0.11.X` -> `0.13.8` upgrade
- [`1.5.7/`](1.5.7/) - Containerized Terraform drop-in scripts for pinning versions (can also be used with DinD for CI/CD scenarios)