MINIKUBE_MEMORY := 8096
MINIKUBE_CPUS := 2
# CILIUM_VERSION := 1.16.4
COCO_VERSION := v0.11.0

# Main target
.PHONY: all
all: minikube kata-setup runtime-setup coco-setup

# Start minikube with required configuration
.PHONY: minikube
minikube:
	minikube start \
		--container-runtime containerd \
		--cni cilium \
		--memory $(MINIKUBE_MEMORY) \
		--vm-driver kvm2 \
		--cpus $(MINIKUBE_CPUS)
	cilium install
	# cilium install --version $(CILIUM_VERSION)

# Setup Kata Containers
.PHONY: kata-setup
kata-setup:
	git clone https://github.com/kata-containers/kata-containers.git || true
	cd kata-containers/tools/packaging/kata-deploy && \
	kubectl apply -f kata-rbac/base/kata-rbac.yaml && \
	kubectl apply -f kata-deploy/base/kata-deploy.yaml
	@echo "Waiting for kata-deploy pod to be ready..."
	kubectl wait --for=condition=ready pod -l name=kata-deploy -n kube-system --timeout=300s

# Setup Runtime Classes
.PHONY: runtime-setup
runtime-setup:
	cd kata-containers/tools/packaging/kata-deploy/runtimeclasses && \
	kubectl apply -f kata-runtimeClasses.yaml

# Install CoCo operator
.PHONY: coco-setup
coco-setup:
	kubectl apply -k "github.com/confidential-containers/operator/config/release?ref=$(COCO_VERSION)"

# Check status
.PHONY: status
status:
	minikube status
	kubectl get pods -n kube-system | grep kata
	kubectl get runtimeclass

# Cleanup
.PHONY: clean
clean:
	minikube delete
