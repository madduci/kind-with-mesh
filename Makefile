#####################
### General Settings
#####################

# Define the root directory
ROOT_DIR ?= $(shell pwd)

# Use Bash as default shell
SHELL := sh
# Set bash strict mode and enable warnings
.ONESHELL:
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
# Making steps silent - don't print all the commands to stdout
.SILENT:

TF_BIN := tofu
WORKING_PATH :=

.PHONY: help
help:
	$(info Creates a local cluster using Kind (Kubernetes in Docker))
	$(info Usage: make <target>)
	$(info )
	$(info Available targets:)
	$(info - create-cluster-cilium:  creates the cluster with Cilium enabled)
	$(info - destroy-cluster-cilium: deletes the cluster with Cilium enabled)
	$(info )
	$(info - create-cluster-istio-ambient:   creates the cluster with Istio enabled - Ambient Mode)
	$(info - destroy-cluster-istio-ambient:  deletes the cluster with Istio enabled - Ambient Mode)
	$(info )
	$(info - create-cluster-istio-sidecar:   creates the cluster with Istio enabled - Sidecar Mode)
	$(info - destroy-cluster-istio-sidecar:  deletes the cluster with Istio enabled - Sidecar Mode)

.PHONY: create-cluster-istio-ambient
create-cluster-istio-ambient: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-istio-ambient
create-cluster-istio-ambient: init apply ## Creates a local cluster with Istio (Ambient Mode) enabled
	@echo "Created the cluster with Istio (Ambient Mode) enabled"

.PHONY: create-cluster-istio-sidecar
create-cluster-istio-sidecar: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-istio-sidecar
create-cluster-istio-sidecar: init apply ## Creates a local cluster with Istio (Sidecar Mode) enabled
	@echo "Created the cluster with Istio (Sidecar Mode) enabled"

.PHONY: create-cluster-cilium
create-cluster-cilium: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-cilium
create-cluster-cilium: init apply ## Creates a local cluster with Cilium enabled
	@echo "Created the cluster with Cilium enabled"

.PHONY: destroy-cluster-istio-ambient
destroy-cluster-istio-ambient: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-istio-ambient
destroy-cluster-istio-ambient: destroy
destroy-cluster-istio-ambient: ## Destroys a previously created local cluster with Istio (Ambient Mode)
	@echo "Destroyed the cluster with Istio (Ambient Mode)"

.PHONY: destroy-cluster-istio-sidecar
destroy-cluster-istio-sidecar: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-istio-sidecar
destroy-cluster-istio-sidecar: destroy
destroy-cluster-istio-sidecar: ## Destroys a previously created local cluster with Istio (Sidecar Mode)
	@echo "Destroyed the cluster with Istio (Sidecar Mode)"

.PHONY: destroy-cluster-cilium
destroy-cluster-cilium: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-cilium
destroy-cluster-cilium: destroy
destroy-cluster-cilium: ## Destroys a previously created local cluster with Cilium
	@echo "Destroyed the cluster with Cilium"

.PHONY: fmt
fmt: ## Performs auto-formatting of the code
	$(TF_BIN) fmt -recursive

.PHONY: lint
lint: ## Performs linting
	tflint --init
	tflint --recursive \
			--config="$(ROOT_DIR)/.tflint.hcl" \
			--minimum-failure-severity=warning

.PHONY: docs
docs: ## Generates documentation for all terraform modules
	@echo "## Generating documentation for all terraform modules"
	@for dir in $(shell find $(ROOT_DIR) -name '*.tf' -exec dirname {} \; | sort -u); do \
		terraform-docs -c "$(ROOT_DIR)/.tfdocs.yaml" "$$dir"; \
	done

init: ## Initializes the working directory
	cd $(WORKING_PATH)
	$(TF_BIN) init
	$(TF_BIN) validate
	cd -

apply: ## Applies the terraform/tofu configuration
	cd $(WORKING_PATH)
	$(TF_BIN) apply -auto-approve
	cd -

destroy: ## Destroys the cluster and removes the config file
	cd $(WORKING_PATH)
	$(TF_BIN) destroy -auto-approve
	rm -f local-cluster-config || echo "File not found, skipping"
	cd -
