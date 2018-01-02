#!/bin/bash

helm delete demo --purge
helm install riffrepo/riff --name demo --set httpGateway.service.type=NodePort

echo -e "\n\nTo configure your terminal, run...\n
eval \$(minikube docker-env)
export GATEWAY=\`minikube service --url demo-riff-http-gateway\`
export HEADER=\"Content-Type: text/plain\"
"