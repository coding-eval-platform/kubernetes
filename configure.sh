#!/bin/bash
set -e

# # Install tiller
# echo "Installing tiller"
# kubectl create serviceaccount tiller \
#     -n kube-system
# kubectl create clusterrolebinding tiller \
#   --clusterrole=cluster-admin \
#   --serviceaccount=kube-system:tiller
# helm init --service-account tiller

# # Wait some time till tiller starts
# echo "Sleeping 15 seconds till tiller starts"
# sleep 15

# Install the Postgres Operator
echo "Installing the postgres operator"
POSTGRES_OPERATOR_PATH=$HOME/opt/zalando-postgres-operator
POSTGRES_OPERATOR_TAR_GZ=$POSTGRES_OPERATOR_PATH/zalando-postgres-operator.tar.gz
mkdir -p $POSTGRES_OPERATOR_PATH
curl https://github.com/zalando/postgres-operator/archive/v1.6.3.tar.gz -sL --output $POSTGRES_OPERATOR_TAR_GZ
tar -xzvf $POSTGRES_OPERATOR_TAR_GZ -C $POSTGRES_OPERATOR_PATH
rm $POSTGRES_OPERATOR_TAR_GZ
helm install \
    zalando-postgres-operator \
    $POSTGRES_OPERATOR_PATH/postgres-operator-1.6.3/charts/postgres-operator

# Add Banzai's and Jetstack helm repositories
echo "Adding needed repositories to install zookeeper and kafka operators"
helm repo add banzaicloud-stable http://kubernetes-charts.banzaicloud.com/branch/master
helm repo add jetstack https://charts.jetstack.io

# Install the Zookeeper Operator
echo "Installing the zookeeper operator"
helm install \
    banzai-zookeeper-operator \
    banzaicloud-stable/zookeeper-operator

# Install the Cert Manager
echo "Installing the cert-manager operator (needed by the kafka operator)"
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.10/deploy/manifests/00-crds.yaml
helm install \
    cert-manager \
    --version v0.10.1 \
    jetstack/cert-manager

# # Wait some time till cert manager stuff is available
echo "Sleeping 60 seconds till cert manager stuff is available"
sleep 60

# Install the Kafka Operator
echo "Installing the kafka operator"
helm install \
    banzai-kafka-operator \
    --version 0.2.4 \
    banzaicloud-stable/kafka-operator
