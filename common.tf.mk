ifeq (, $(ENVIRONMENT))
$(error ENVRIONMENT must be set, e.g. `ENVIRONMENT=staging make <TARGET>`)
endif

ifeq (, $(TF_VERSION))
$(error "TF_VERSION must be set")
endif

export TF_PLUGIN_CACHE_DIR = $(shell git rev-parse --show-toplevel)/.terraform.d/plugin-cache

# Configuration Overrides
REGION      ?= us-west-2
TFVARS_FILE ?= $(ENVIRONMENT).tfvars

# Constants
TERRAFORM_CMD := cd tfsrc && terraform
TF_CURRENT    := $(shell tfenv version-name)

.PHONY: init
init: tfenv
	@echo "initializing terraform"
	@$(TERRAFORM_CMD) init -backend-config "region=$(REGION)"

.PHONY: plan
plan: init validate
	@echo "creating terraform plan"
ifeq ($(TFVARS_FILE),)
	@$(TERRAFORM_CMD) plan \
		-var 'environment=$(ENVIRONMENT)' \
		-out terraform.plan
else
	@$(TERRAFORM_CMD) plan \
		-var 'environment=$(ENVIRONMENT)' \
		-var-file="$(TFVARS_FILE)" \
		-out terraform.plan
endif

.PHONY: apply
apply: plan
	@echo "applying plan"
	@$(TERRAFORM_CMD) apply terraform.plan

.PHONY: destroy
destroy: init
	@echo "destroying deployment environment/workspace '$(ENVIRONMENT)'"
ifeq ($(TFVARS_FILE),)
	@$(TERRAFORM_CMD) destroy \
		-var 'environment=$(ENVIRONMENT)' \
else
	@$(TERRAFORM_CMD) destroy \
		-var 'environment=$(ENVIRONMENT)' \
		-var-file="$(TFVARS_FILE)"
endif

.PHONY: fmt
fmt:
	@$(TERRAFORM_CMD) fmt

.PHONY: validate
	@$(TERRAFORM_CMD) validate

.PHONY: tfenv
tfenv:
	@mkdir -p $(TF_PLUGIN_CACHE_DIR)
ifeq ($(TF_CURRENT), $(TF_VERSION))
	@echo "terraform v$(TF_VERSION) ready to roll..."
else
	@tfenv install $(TF_VERSION)
	@tfenv use $(TF_VERSION)
endif
