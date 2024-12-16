# Base requirements

- 8GB
- 2vCPU
- containerd
- another cni plugin besides the default cni plugin

# Minikube installation

```
minikube start --container-runtime containerd --cni cilium --memory 8096 --vm-driver kvm2 --cpus 2
cilium install --version 1.16.22
```

## Install Kata Containers

```
git clone https://github.com/kata-containers/kata-containers.git
cd kata-containers/tools/packaging/kata-deploy
kubectl apply -f kata-rbac/base/kata-rbac.yaml
kubectl apply -f kata-deploy/base/kata-deploy.yaml
```

Wait for  kata-deploy-ldszh                  0/1     ContainerCreating   0            116s
 to go into state running

## Register runtime

```
git clone https://github.com/kata-containers/kata-containers
cd kata-containers/tools/packaging/kata-deploy/runtimeclasses
kubectl apply -f kata-runtimeClasses.yaml
```

## CoCo operator
CoCo operator

```
export RELEASE_VERSION="v0.9.0"
kubectl apply -k "github.com/confidential-containers/operator/config/release?ref=${RELEASE_VERSION}"
```
