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
	$(info - install-cluster-cilium:  creates the cluster with Cilium enabled)
	$(info - uninstall-cluster-cilium: deletes the cluster with Cilium enabled)
	$(info )
	$(info - install-cluster-istio-ambient:   creates the cluster with Istio enabled - Ambient Mode)
	$(info - uninstall-cluster-istio-ambient:  deletes the cluster with Istio enabled - Ambient Mode)
	$(info )
	$(info - install-cluster-istio-sidecar:   creates the cluster with Istio enabled - Sidecar Mode)
	$(info - uninstall-cluster-istio-sidecar:  deletes the cluster with Istio enabled - Sidecar Mode)

.PHONY: create-cluster
create-cluster: export WORKING_PATH=$(ROOT_DIR)/examples/kind
create-cluster: init apply ## Creates a local cluster with Istio (Ambient Mode) enabled
	@echo "Created the cluster"

.PHONY: install-cluster-istio-ambient
install-cluster-istio-ambient: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-istio-ambient
install-cluster-istio-ambient: init apply ## Creates a local cluster with Istio (Ambient Mode) enabled
	@echo "Installed Istio (Ambient Mode) enabled"

.PHONY: install-cluster-istio-sidecar
install-cluster-istio-sidecar: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-istio-sidecar
install-cluster-istio-sidecar: init apply ## Creates a local cluster with Istio (Sidecar Mode) enabled
	@echo "Installed Istio (Sidecar Mode) enabled"

.PHONY: install-cluster-cilium
install-cluster-cilium: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-cilium
install-cluster-cilium: init apply ## Creates a local cluster with Cilium enabled
	@echo "Installed Cilium enabled"

.PHONY: destroy-cluster
destroy-cluster: export WORKING_PATH=$(ROOT_DIR)/examples/kind
destroy-cluster: destroy
destroy-cluster: ## Destroys a previously created local cluster
	@echo "Destroyed the cluster"

.PHONY: uninstall-cluster-istio-ambient
uninstall-cluster-istio-ambient: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-istio-ambient
uninstall-cluster-istio-ambient: destroy
uninstall-cluster-istio-ambient: ## Destroys a previously created local cluster with Istio (Ambient Mode)
	@echo "Uninstalled Istio (Ambient Mode)"

.PHONY: uninstall-cluster-istio-sidecar
uninstall-cluster-istio-sidecar: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-istio-sidecar
uninstall-cluster-istio-sidecar: destroy
uninstall-cluster-istio-sidecar: ## Destroys a previously created local cluster with Istio (Sidecar Mode)
	@echo "Uninstalled Istio (Sidecar Mode)"

.PHONY: uninstall-cluster-cilium
uninstall-cluster-cilium: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-cilium
uninstall-cluster-cilium: destroy
uninstall-cluster-cilium: ## Uninstalls a previously created local cluster with Cilium
	@echo "Uninstalled Cilium"

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
