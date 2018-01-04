Chain
===

An example of chaining the output of one function to the input of another.

This example includes two functions, [greeting](https://github.com/BrianMMcClain/riff-demos/tree/master/functions/chain/greeting) and [timestamp](https://github.com/BrianMMcClain/riff-demos/tree/master/functions/chain/timestamp). 

Greeting Function
---

The `greeting` function takes in a User's name and constructs a simple greeting.

|     | Type  | Example      |
|-----|-------|--------------|
|Input |String|"World"       |
|Output|String|"Hello, World"|

Timestamp Function
---

The `timestamp` function takes in a string and adds a timestamp to the beginning of it.

|     | Type  | Example                            |
|-----|-------|------------------------------------|
|Input |String|"Hello, World"                      |
|Output|String|"[2018-01-04 21:18:57] Hello, World"|

Putting it Together
---
Riff allows the chaining together of functions easily by defining the input and output topics for each function.

The [greeting.yml](https://github.com/BrianMMcClain/riff-demos/tree/master/functions/chain/greeting/greeting.yml) file defines that inputs will be taken from the `greeting` topic. After running the function, it then defines that all output will be sent to the `timestamp` topic.

The `timestamp` function then picks this up off of the `timestamp` topic, executes the function and then returns the final results to the user.

Building It
---
The functions are built and applied just as any other function, but you may run the [build.sh](https://github.com/BrianMMcClain/riff-demos/tree/master/functions/chain/build.sh) script to get both functions up and running

```
./build.sh
```

Trying it Out
---
If you havn't already, ensure your shell environment is setup with the Riff HTTP Gateway
```
export GATEWAY=`minikube service --url demo-riff-http-gateway`
export HEADER="Content-Type: text/plain"
```

And then call the function
```
curl $GATEWAY/requests/greeting -H "$HEADER" -d "World"
```

Which will return:
```
[2018-01-04 21:34:57] Hello, World
```