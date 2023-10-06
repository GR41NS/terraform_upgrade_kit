ENVIRONMENT ?= staging
TF_VERSION  := 0.13.7

include $(shell git rev-parse --show-toplevel)/common.docker.mk
include $(shell git rev-parse --show-toplevel)/common.tf.mk


.PHONY: 0.13upgrade
0.13upgrade: init validate
	@echo "updating to terraform v0.13"
	$(TERRAFORM_CMD) 0.13upgrade
