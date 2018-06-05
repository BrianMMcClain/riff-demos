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
minikube start --memory=4096 --bootstrapper=kubeadm
eval $(minikube docker-env)

# Setup Helm
echo "Setting up Helm..."
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account=tiller

helm repo add projectriff https://riff-charts.storage.googleapis.com
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
helm install projectriff/riff --version 0.0.7 --name projectriff --namespace riff-system --set kafka.create=true --set httpGateway.service.type=NodePort --wait

# Install the Riff CLI
echo "Installing Riff CLI..."
# go get -u github.com/projectriff/riff
# The current dev build has some inconsistancies, so pull
# a static build
curl -Lo riff-darwin-amd64.tgz https://github.com/projectriff/riff/releases/download/v0.0.7/riff-darwin-amd64.tgz
tar xvzf riff-darwin-amd64.tgz
mv riff /usr/local/bin/

RIFF_PATH=`which riff`
if [ "$RIFF_PATH" != "/usr/local/bin/riff" ]
then
    echo "Current Riff path is not /usr/local/bin/riff"
    echo "Patching current Riff location with correct build"
    cp /usr/local/bin/riff $RIFF_PATH
fi

# Wait for Riff to start
echo "Waiting for Riff to start..."
RIFF_WAIT=0
until kubectl get po,deploy --namespace riff-system | grep Running | wc -l | grep 5 1> /dev/null 2> /dev/null
do
  sleep 5
  RIFF_WAIT=$((RIFF_WAIT+1))
  if [ $RIFF_WAIT -eq 30 ]
  then
      echo "Could not connect to Riff, exiting!"
      exit -1
  fi
done

echo "Riff ready!"

# Install Riff invokers
echo "Installing Riff invokers..."
riff invokers apply -f https://github.com/projectriff/command-function-invoker/raw/v0.0.6/command-invoker.yaml
riff invokers apply -f https://github.com/projectriff/go-function-invoker/raw/v0.0.3/go-invoker.yaml
riff invokers apply -f https://github.com/projectriff/java-function-invoker/raw/v0.0.7/java-invoker.yaml
riff invokers apply -f https://github.com/projectriff/node-function-invoker/raw/v0.0.8/node-invoker.yaml
riff invokers apply -f https://github.com/projectriff/python3-function-invoker/raw/v0.0.6/python3-invoker.yaml

echo -e "\n\nTo configure your terminal, run...\n
eval \$(minikube docker-env)
export GATEWAY=\`minikube service --url projectriff-riff-http-gateway --namespace riff-system\`
export HEADER=\"Content-Type: text/plain\"
"