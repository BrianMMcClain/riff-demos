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
```

```
riff create java -a target/counter-1.0.0-jar-with-dependencies.jar --handler functions.Counter
```

Call the Function
---
```
export GATEWAY=`minikube service --url demo-riff-http-gateway`
export HEADER="Content-Type: text/plain"

curl $GATEWAY/requests/counter -H "$HEADER"
```
