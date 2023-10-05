## ~ 0.11 -> 0.13

1. Update your main `.tf`:

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

2. Run `make` to start the container.
3. Once inside the container, run `make init` (pass in any required [configuration parameters](../README.md#configuration-parameters-and-defaults)). You should see the message below. If there are errors, you'll have to fix `em :P

    ```
    d4b81dfde410:/app/0.13# TFVARS_FILE=staging.tfvars make init
    
    ...

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ```

4. Fix any warnings or errors until you get a clean `init`