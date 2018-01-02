Couter Riff Demo
===

A small example of a Riff function that returns an increasing number with each call, using Redis on the back end.

Install the Redis Chart
---
```
helm install --name riff --set usePassword=false --set persistence.enabled=false stable/redis
```

Build and Create the Function
---
```
mvn install
mvn package
riff build -n counter -v 0.0.1 -f .
riff apply -f .
```

Call the Function
---
```
export GATEWAY=`minikube service --url demo-riff-http-gateway`
export HEADER="Content-Type: text/plain"

curl $GATEWAY/requests/counter -H "$HEADER"
```
