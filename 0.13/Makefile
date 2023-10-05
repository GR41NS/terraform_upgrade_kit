TF_VERSION  := 0.13.7

include $(shell git rev-parse --show-toplevel)/common.docker.mk
include $(shell git rev-parse --show-toplevel)/common.tf.mk


.PHONY: 0.13upgrade
0.13upgrade: init validate
	@echo "updating to terraform v0.13"
ifeq ($(TFVARS),)
	@$(TERRAFORM_CMD) 0.13upgrade \
		-var 'environment=$(ENVIRONMENT)' \
		-var 'build_tag=$(BUILD_TAG)' \
		-out terraform.plan
else
	@$(TERRAFORM_CMD) 0.13upgrade \
		-var 'environment=$(ENVIRONMENT)' \
		-var 'build_tag=$(BUILD_TAG)' \
		-var-file="$(TFVARS)" \
		-out terraform.plan
endif
