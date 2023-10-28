#####################
### General Settings
#####################

# Use Bash as default shell
SHELL := sh
# Set bash strict mode and enable warnings
.ONESHELL:
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
# Making steps silent - don't print all the commands to stdout
.SILENT:

.PHONY: help
help:
	$(info Creates a local cluster using Kind (Kubernetes in Docker))
	$(info Usage: make <target>)
	$(info )		
	$(info Available targets:)
	$(info - create:  creates the cluster)
	$(info - cilium:  configures Ciliu, in the cluster)
	$(info - istio:   configures Istio in the cluster)
	$(info - cleanup: deletes the cluster)

.PHONY: create
create:
	cd cluster
	terraform init -upgrade
	terraform apply -auto-approve

.PHONY: cleanup
cleanup:
	cd cluster
	terraform destroy -auto-approve
	rm -f local-cluster-config || echo "File not found, skipping"

.PHONY: istio
istio:
	cd istio
	terraform init -upgrade
	terraform apply -auto-approve

.PHONY: cilium
cilium:
	cd cilium
	terraform init -upgrade
	terraform apply -auto-approve