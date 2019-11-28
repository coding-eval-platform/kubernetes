# Kubernetes

Repository containing Kubernetes files that enables the deploy in a Kubernetes cluster


## Getting started

The following steps will guide you to prepare a Kubernetes cluster in order to deploy the whole platform.

This guide covers only MacOS setups.

### Prerequisites

#### Kubernetes cluster

You will need a Kubernetes cluster up and running. You can check [this guide](https://github.com/coding-eval-platform/infrastructure-guides/blob/master/aws/README.md) which explains how to set up a cluster in AWS. You can also check [minikube](https://github.com/kubernetes/minikube) for a local cluster.

#### Kubernetes CLI

The Kubernetes CLI (`kubectl`) is required. You can install it with the following command:

```
$ brew install kubernetes-cli
```

More information about kubectl can be found [here](https://kubernetes.io/docs/reference/kubectl/overview/).


#### Kustomize

This tool allows applying configuration in a simple way. It is a required tool. You can install it with the following command:

```
$ brew install kustomize
```

More information about kustomize can be found [here](https://kustomize.io/).


#### Helm and Tiller

Helm is a tool for managing Charts. Charts are packages of pre-configured Kubernetes resources. Tiller is the server-side counterpart of Helm, which must be installed in the cluster.
You can install Helm using the following commands:

```
$ brew install helm@2
$ echo 'export PATH="/usr/local/opt/helm@2/bin:$PATH"' >> ~/.bash_profile   # Needed as it is not symlinked

# Needed only if you want to continue in the same terminal (next time you open a terminal, it won't be needed)
$ source ~/.bash_profile
```

Tiller will be configured in the cluster afterwards (in the cluster configuration step).

More information about helm can be found [here](https://helm.sh/).


### Cluster configuration

Once all the software is installed, run the configuration script included in this repository:

```
$ bash ~/configure.sh
```

This will install support resources in the cluster, which will allow deploying the platform.

## Deploying the platform

The whole platform can be deployed with just one command:

```
$ kustomize build deployment | kubectl apply -f -
```

This will create in the cluster all the needed resources to get the whole platform up and running.

You can perform some verifications over the deployment:

```
$ kubectl get pods      # Check which pods are running
$ kubectl get services  # Check which services are deployed
```


<!-- ### Updating a specific component -->

If you want to update a specific component (say you want to give more cpu to the executor service), you can execute the following command (it will only apply the new configuration to those components):

```
# After changing the corresponding yaml file...
$ kubectl apply -k deployment/executor-service
```


## License

Copyright 2019 Bellini & Lobo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
