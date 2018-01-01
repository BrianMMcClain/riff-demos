#!/bin/bash

helm delete demo --purge
helm install riffrepo/riff --name demo --set httpGateway.service.type=NodePort