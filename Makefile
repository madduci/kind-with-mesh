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

.PHONY: cluster
cluster: init
	cd cluster
	terraform apply -auto-approve $$MESH_OPTS
	cd -

.PHONY: cluster-istio
cluster-istio:
	@echo "Creating the cluster with Istio enabled"
	$(MAKE) cluster MESH_OPTS="--var=enable_istio=true"

.PHONY: cluster-cilium
cluster-cilium:
	@echo "Creating the cluster with Cilium enabled"
	$(MAKE) cluster MESH_OPTS="--var=enable_cilium=true"

.PHONY: init
init: 
	cd cluster
	terraform init -upgrade -reconfigure
	cd -

.PHONY: cleanup
cleanup:
	cd cluster
	terraform destroy -auto-approve
	rm -f local-cluster-config || echo "File not found, skipping"
	cd -
