ifeq (, $(TF_VERSION))
$(error "TF_VERSION must be set")
endif

# Path to your .tf files, mounted as writable under `./tfsrc`
TF_SRC_PATH ?= $(HOME)/git/ztrack-consumers/provisioning/terraform
# Additional volumes can be added by appending `-v foo:bar`
ADD_VOLUMES ?= -v $(HOME)/.aws:/root/.aws
# In case you need to pass your SSH key to the container...
SSH_KEY     ?= $(HOME)/.ssh/id_rsa

# Constants
DOCKER_BUILD_PATH := ../
IMAGE_NAME        := terraform_upgrade_kit
BUILD_TAG         := $(shell whoami)-$(shell git rev-parse --short HEAD)
DOCKER_IMAGE      := ${IMAGE_NAME}:${BUILD_TAG}

CURR_DIR  := $(shell pwd | awk -F '/' '{print $$NF}')
REPO_ROOT := $(shell git rev-parse --show-toplevel)

.PHONY: all
all: run

.PHONY: run
run: build
	@docker run \
		-it \
		--rm \
		-v $(REPO_ROOT):/app \
		-v $(TF_SRC_PATH):/app/$(CURR_DIR)/tfsrc \
		$(ADD_VOLUMES) \
		$(DOCKER_IMAGE)

.PHONY: build
build:
	@echo "building $(DOCKER_IMAGE)"
	@DOCKER_BUILDKIT=1 docker build \
		--ssh default=$(SSH_KEY) \
		--build-arg TV=$(TF_VERSION) \
		--build-arg CD=$(CURR_DIR) \
		-t $(DOCKER_IMAGE) \
		$(DOCKER_BUILD_PATH)
