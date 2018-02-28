#!/bin/bash

set -e

# Install HomeBrew if it doesn't exist
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    brew update
fi

# Ensure wget is installed
brew install wget

# Install minikube
echo "Installing Minikube CLI..."
brew cask install minikube

# Install Helm
echo "Installing Helm CLI..."
brew install kubernetes-helm

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


# Install Kafka and Riff
echo "Installing Kafka and Riff..."
kubectl create namespace riff-system
helm install --name transport --namespace riff-system riffrepo/kafka
helm install riffrepo/riff --version 0.0.4 --name demo --set rbac.create=false --set httpGateway.service.type=NodePort

# Install the Riff CLI
echo "Installing Riff CLI..."
go get github.com/projectriff/riff


echo -e "\n\nTo configure your terminal, run...\n
eval \$(minikube docker-env)
export GATEWAY=\`minikube service --url demo-riff-http-gateway\`
export HEADER=\"Content-Type: text/plain\"
"