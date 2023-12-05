# Variables
SHELL := /bin/bash
ORGANIZATION := atrawog
DEFAULT_TAG := latest
DATE_TAG := $(shell date +%Y%m%d)

# Default Docker Buildx builder
BUILDER := default

# Path to the Docker Bake template and output file
STAGES := base core jupyter ai spatial testing devel
BAKE_TEMPLATE := docker-bake.template.hcl
BAKE_FILE := docker-bake.hcl

# Build
BOOK_BUILD_DIR = _build/html

# Default version
MICROMAMBA_VERSION := 1.5.3

# Default target architecture
ARCH := $(shell uname -m)

# Determine architecture for micromamba
ifeq ($(ARCH),x86_64)
	ARCH := 64
else ifeq ($(ARCH),aarch64)
	ARCH := aarch64
else ifeq ($(ARCH),ppc64le)
	ARCH := ppc64le
else
	$(error Architecture not supported)
endif

MAMBA_EXE := /bin/micromamba
INSTALL_DIR := /bin

# Install micromamba
.PHONY: micromamba-install
micromamba-install:
	@echo "Installing micromamba version $(MICROMAMBA_VERSION) for architecture: $(ARCH)"
	@curl -L "https://micro.mamba.pm/api/micromamba/linux-$(ARCH)/$(MICROMAMBA_VERSION)" | sudo tar -xj -C "$(dir $(INSTALL_DIR))"

.PHONY: micromamba-activate
micromamba-activate:
	@export MAMBA_EXE='/bin/micromamba';
	@export MAMBA_ROOT_PREFIX='.micromamba';
	@micromamba install -f env/env_python.yaml
	@eval "$(micromamba shell hook --shell bash)"
	@/bin/micromamba activate

# Build task
.PHONY: docker-build
docker-build:
	# Generate the actual docker-bake.hcl from the template
	sed "s/ORG_PLACEHOLDER/$(ORGANIZATION)/g; s/DEFAULT_TAG_PLACEHOLDER/$(DEFAULT_TAG)/g; s/DATE_TAG_PLACEHOLDER/$(DATE_TAG)/g" $(BAKE_TEMPLATE) > $(BAKE_FILE)

	# Use the default Docker Buildx builder
	docker buildx use $(BUILDER)

	# Build the images using the generated Docker Bake file
	DOCKER_BUILDKIT=1 docker buildx bake -f $(BAKE_FILE)

# Push task
.PHONY: docker-push
docker-push:
	@$(foreach stage,$(STAGES), \
		docker push $(ORGANIZATION)/$(stage):$(DEFAULT_TAG); \
		docker push $(ORGANIZATION)/$(stage):$(DATE_TAG);)

