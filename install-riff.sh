#!/bin/bash

set -e

if [ $# -lt 1 ]
then
    echo "USAGE: ./install-riff DOCKER_ID"
    exit 1
fi
DOCKER_ID=$1

# Install HomeBrew if it doesn't exist
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    echo "Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Running 'brew update'..."
    brew update
fi

# Install minikube
which -s brew
if [[ $? != 0 ]] ; then
    echo "Installing Minikube CLI..."
    brew cask install minikube
fi

# Start Minikube
echo "Starting Minikube..."
minikube start --memory=4096 --cpus=4 \
--kubernetes-version=v1.14.0 \
--vm-driver=hyperkit \
--bootstrapper=kubeadm \
--extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"
eval $(minikube docker-env)

# Install the riff CLI
which -s riff
if [[ $? != 0 ]] ; then
    echo "Installing riff CLI..."
    brew install riff
fi

# Install riff
echo "Installing riff..."
riff system install --node-port

# Wait for Riff to start
echo "Waiting for Riff to start..."
RIFF_WAIT=0
until kubectl get po,deploy --all-namespaces | grep Running | wc -l | grep 5 1> /dev/null 2> /dev/null
do
  sleep 5
  RIFF_WAIT=$((RIFF_WAIT+1))
  if [ $RIFF_WAIT -eq 30 ]
  then
      echo "Could not connect to Riff, exiting!"
      exit -1
  fi
done

riff namespace init default --docker-hub $DOCKER_ID

echo "Riff ready!"