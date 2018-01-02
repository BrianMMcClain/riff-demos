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
TILLER_WAIT=0
until helm version 1> /dev/null 2> /dev/null
do
  sleep 1
  TILLER_WAIT=$((TILLER_WAIT+1))
  if [ $TILLER_WAIT -eq 30 ]
  then
      echo "Could not connect to Tiller, exiting!"
      exit -1
  fi
done

echo "Tiller ready!"


# Install Riff
echo "Installing Riff..."
helm install riffrepo/riff --name demo --set httpGateway.service.type=NodePort

# Install the Riff CLI
echo "Installing Riff CLI..."
wget https://raw.githubusercontent.com/projectriff/riff/583246872ac95871073f160e5baae895035caa61/riff -O riff
chmod +x riff
mv riff /usr/local/bin/riff


echo -e "\n\nTo configure your terminal, run...\n
eval \$(minikube docker-env)
export GATEWAY=\`minikube service --url demo-riff-http-gateway\`
export HEADER=\"Content-Type: text/plain\"
"