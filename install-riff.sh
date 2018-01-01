#!/bin/bash

# Install minikube
echo "Installing Minikube CLI..."
wget https://github.com/kubernetes/minikube/releases/download/v0.24.1/minikube-darwin-amd64 -O minikube && chmod +x minikube && mv minikube /usr/local/bin/minikube
minikube version

# Install Helm
echo "Installing Helm CLI..."
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.7.2-darwin-amd64.tar.gz -O helm.tar.gz
tar -xf helm.tar.gz
mv darwin-amd64/helm /usr/local/bin/helm
rm -rf darwin-amd64 helm.tar.gz

# Start Minikube
echo "Starting Minikube..."
minikube start --memory=4096

# Setup Helm
echo "Setting up Helm..."
helm init
helm repo add riffrepo https://riff-charts.storage.googleapis.com
helm repo update

# Wait for Tiller to start
echo "Waiting for Tiller to start..."
sleep 45

# Install Riff
echo "Installing Riff..."
helm install riffrepo/riff --name demo --set httpGateway.service.type=NodePort

# Point to the minikube docker daemon
echo "Configuring minikube docker daemon..."
eval $(minikube docker-env)

# Setup the gateway
echo "Setting up HTTP Gateway..."
GATEWAY=`minikube service --url demo-riff-http-gateway`