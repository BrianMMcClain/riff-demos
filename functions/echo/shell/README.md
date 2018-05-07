echo-shell
===

The "Hello World" of Riff, the echo-shell function takes in a string and echos it back at the user

Build and Deploy the Function
---
```
riff create command --name echo-shell --filepath . -a echo-shell.sh --input echo-shell
```

Call the Function
---
If you havn't already, ensure your shell environment is setup with the Riff HTTP Gateway
```
export GATEWAY=`minikube service --url projectriff-riff-http-gateway --namespace riff-system`
export HEADER="Content-Type: text/plain"
```

And then call the function
```
curl $GATEWAY/requests/echo-shell -H "$HEADER" -d "Hello World"
```

Which will return:
```
Echoing: Hello World
```

Alternativly, you may use the `riff publish` command, which will also POST the data over the HTTP gateway

```
riff publish --input echo-shell -d "Hello World" -r
```