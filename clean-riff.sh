#!/bin/bash

# Delete functions, topics and any running function pods
FUNCS=`kubectl get functions -o json | jq -r '.items | sort_by(.spec.nodeName)[] | [.metadata.name] | @tsv'`
for FUNC in $FUNCS
do
    kubectl delete function $FUNC 2> /dev/null
    kubectl delete topic $FUNC 2> /dev/null
    PODS=`kubectl get pods -o json | jq -r '.items | sort_by(.spec.nodeName)[] | [.metadata.name] | @tsv' | grep $FUNC`
    sleep 3 # Wait for the function to be deleted
    for POD in $PODS
    do
        kubectl delete pod $POD 2> /dev/null
    done
done

# Delete Riff install
helm delete demo --purge

# Reinstall Riff
helm install riffrepo/riff --name demo --set httpGateway.service.type=NodePort

echo -e "\n\nTo configure your terminal, run...\n
eval \$(minikube docker-env)
export GATEWAY=\`minikube service --url demo-riff-http-gateway\`
export HEADER=\"Content-Type: text/plain\"
"