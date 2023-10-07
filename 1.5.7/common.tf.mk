ifneq ($(ENVIRONMENT),staging)
$(warning Currently only supporting ENVIRONMENT=staging)
ENVIRONMENT := staging
endif

#### Makefile overrides
TFVARS_PATH ?=
TF_VERSION  ?= 1.5.7
AWS_REGION  ?= us-west-2
# Additional Docker volumes can be mounted by appending -v switches, e.g.
# ADD_VOLUMES="-v $(HOME)/.aws:/root/.aws -v foo:bar"
ADD_VOLUMES ?= 

# If running locally, mount AWS Credentials + run interactively with TTY
ifneq ($(CI),true)
CREDENTIALS_VOLUME ?= -v $(HOME)/.aws:/root/.aws
IT                 := -it
endif

#### Dependencies and Globals
export TF_PLUGIN_CACHE_DIR = $(HOME)/.terraform.d/plugin-cache
TF_CMD := docker run --rm $(IT) $(CREDENTIALS_VOLUME) -v ${PWD}:/data $(ADD_VOLUMES) -w /data hashicorp/terraform:$(TF_VERSION)


.PHONY: init
init: clean
	@$(TF_CMD) init
	@$(TF_CMD) workspace new $(ENVIRONMENT) 2>/dev/null || $(TF_CMD) workspace select $(ENVIRONMENT)

.PHONY: init-upgrade
init-upgrade: clean
	@$(TF_CMD) init -upgrade
	@$(TF_CMD) workspace new $(ENVIRONMENT) 2>/dev/null || $(TF_CMD) workspace select $(ENVIRONMENT)

.PHONY: fmt
fmt:
	@$(TF_CMD) fmt

.PHONY: validate
	@$(TF_CMD) validate

.PHONY: plan
plan: init validate
	@echo "creating terraform plan"
ifeq ($(TFVARS_PATH),)
	@$(TF_CMD) plan \
		-var 'environment=$(ENVIRONMENT)' \
		-out terraform.plan
else
	@$(TF_CMD) plan \
		-var 'environment=$(ENVIRONMENT)' \
		-var-file="$(TFVARS_PATH)" \
		-out terraform.plan
endif

.PHONY: apply
apply: plan
	@echo "applying plan"
	@$(TF_CMD) apply terraform.plan

.PHONY: destroy
destroy: init
	@echo "destroying deployment environment/workspace '$(ENVIRONMENT)'"
ifeq ($(TFVARS_PATH),)
	@$(TF_CMD) destroy \
else
	@$(TF_CMD) destroy \
		-var-file="$(TFVARS_PATH)"
endif

.PHONY: clean
clean:
	@rm -rf .terraform/terraform.tfstate terraform.tfstate.d
