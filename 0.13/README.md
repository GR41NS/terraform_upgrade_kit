## ~ 0.11 -> 0.13

1. First, run `terraform plan` for your project + environment, and verify there are no pending changes. A clean plan will remove additional unknowns during the upgrade process.
2. Update your main `.tf`:

    ```php
    terraform {
        required_version = "~> 0.13.7"

        required_providers {
            aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
            }
        }

        backend "s3" {
            region = "us-west-2"
            bucket = "stats-terraform"
            key    = "ztrack-consumers/staging/terraform.tfstate"
            dynamodb_table = "stats-terraform-locks"
        }
    }

    provider "aws" {
        profile = "default"
        region  = "us-west-2"
    }
    ```

3. Run `make` to start the container.
4. Once inside the container, run `make init` (pass in any required [configuration parameters](../README.md#configuration-parameters-and-defaults)). You should see the message below. If there are errors, you'll have to fix `em :P

    ```shell
    # ENVIRONMENT=staging make init
    
    ...

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ```

5. Fix any warnings or errors until you get a clean `init`
6. Run `ENVIRONMENT=staging make plan`, and fix all syntax errors until you you receive a valid plan result:

    ```shell
    # ENVIRONMENT=staging make plan

    ...

    Plan: 269 to add, 0 to change, 0 to destroy.

    ------------------------------------------------------------------------

    This plan was saved to: terraform.plan

    To perform exactly these actions, run the following command to apply:
        terraform apply "terraform.plan"

    Releasing state lock. This may take a few moments...
    ```

7. Run `ENVIRONMENT=staging make 0.13upgrade`

Run a destroy (done)
Deploy on 0.11
Change to using workspace_key_prefix
init/plan on 0.13
0.13upgrade on 0.13
apply
plan!