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
	$(info - create-cluster-nginx:   creates the cluster with nginx ingress)
	$(info - destroy-cluster-nginx:  deletes the cluster with nginx ingress)
	$(info )
	$(info - create-cluster-cilium:  creates the cluster with Cilium enabled)
	$(info - destroy-cluster-cilium: deletes the cluster with Cilium enabled)
	$(info )
	$(info - create-cluster-istio:   creates the cluster with Istio enabled)
	$(info - destroy-cluster-istio:  deletes the cluster with Istio enabled)

.PHONY: create-cluster-nginx
create-cluster-nginx: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-nginx
create-cluster-nginx: init
create-cluster-nginx: apply
create-cluster-nginx: ## Creates a local cluster with nginx ingress
	@echo "Created the cluster with nginx ingress"

.PHONY: create-cluster-istio
create-cluster-istio: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-istio
create-cluster-istio: init
create-cluster-istio: apply
create-cluster-istio: ## Creates a local cluster with Istio enabled
	@echo "Created the cluster with Istio enabled"

.PHONY: create-cluster-cilium
create-cluster-cilium: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-cilium
create-cluster-cilium: init
create-cluster-cilium: apply
create-cluster-cilium: ## Creates a local cluster with Cilium enabled
	@echo "Created the cluster with Cilium enabled"

.PHONY: destroy-cluster-nginx
destroy-cluster-nginx: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-nginx
destroy-cluster-nginx: destroy
destroy-cluster-nginx: ## Destroys a previously created local cluster with nginx ingress
	@echo "Created the cluster with nginx ingress"

.PHONY: destroy-cluster-istio
destroy-cluster-istio: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-istio
destroy-cluster-istio: destroy
destroy-cluster-istio: ## Destroys a previously created local cluster with Istio 
	@echo "Created the cluster with Istio enabled"

.PHONY: destroy-cluster-cilium
destroy-cluster-cilium: export WORKING_PATH=$(ROOT_DIR)/examples/kind-with-cilium
destroy-cluster-cilium: destroy
destroy-cluster-cilium: ## Destroys a previously created local cluster with Cilium
	@echo "Created the cluster with Cilium enabled"

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
	@for dir in $(shell find $(ROOT_DIR)/modules -name '*.tf' -exec dirname {} \; | sort -u); do \
		terraform-docs -c "$(ROOT_DIR)/.tfdocs.yaml" "$$dir"; \
	done

init: ## Initializes the working directory
	cd $(WORKING_PATH)
	$(TF_BIN) init -upgrade -reconfigure
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
