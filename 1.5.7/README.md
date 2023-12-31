# 1.5.7

The `common.tf.mk` file can be dropped into an existing project to run Terraform 1.X inside of a Docker container.

No breaking config changes are required from 0.13 -> 1.5.7

# Configuration

Variables can be passed at runtime, e.g.:
`REGION=us-west-2 TFVARS_PATH=foo.tfvars make init`

- `TFVARS_PATH ?= `
- `TF_VERSION  ?= 1.5.7`
- `REGION  ?= us-west-2`
- `ADD_VOLUMES="-v $(HOME)/.aws:/root/.aws -v foo:bar"`
- `CREDENTIALS_VOLUME ?= -v $(HOME)/.aws:/root/.aws`

## Usage

1. Copy `common.tf.mk` into your project.
2. Add or replace `Makefile` using the example.
3. Use `make <TARGET>` to run Terraform as you normally would:

    ```
    make init
    ENVIRONMENT=staging TFVARS_PATH=staging.tfvars make plan
    ENVIRONMENT=staging TFVARS_PATH=staging.tfvars make apply
    ```