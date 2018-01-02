Riff Demos
===

A collection of demo functions and helper scripts to get up and running with [Riff](https://github.com/projectriff/riff), an OSS solution that provides Functions-as-a-Service for Kubernetes.

install-riff.sh
---
This script will handle installing and configuring minikube, helm and riff on OSX, however it is up to the user to install VirtualBox and Docker ahead of time

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Docker](https://store.docker.com/editions/community/docker-ce-desktop-mac)
3. Run the [install-riff.sh](https://github.com/BrianMMcClain/riff-demos/blob/master/install-riff.sh) script
4. Setup your shell environment by running the commands displayed once the script finishes executing:

```
eval $(minikube docker-env)
export GATEWAY=`minikube service --url demo-riff-http-gateway`
export HEADER="Content-Type: text/plain"
```

If you'd like to keep an eye on what pods, topics and functions are configured, you can watch the status of minikube with the following:

```
watch -n 3 kubectl get functions,topics,pods,services,deploy
```

NOTE: This may give an error until you configure your first function, this is expected.

clean-riff.sh
---
This script will simply delete the existing Riff install and reinstall it, so any functions and topics will need to be reapplied.

Functions
---
The [functions](https://github.com/BrianMMcClain/riff-demos/tree/master/functions) directory contains a series of demos to show off various features of Riff. A great place to start is in the echo example, which contains examples of the same functionality in multiple supported languages. Every demo will include a README on how to setup and run them.

Stopping and Starting Minikube
---
Should you need to stop the VM, it's recommended that do so via the Minikube CLI, such as:

```
minikube stop
```

This will gracefully shut down Kubernetes and the VM it's running on. Then, to restore it, you can simply run:

```
minikube start
```

Which will bring everything back up to how it was previously running. Once the command returns, it will take some time for the pods to be back up and running, so be sure to monitor their progress with:

```
watch -n 3 kubectl get functions,topics,pods,services,deploy
```

Tearing It Down
---
If you need to tear down the whole environment (Riff, Minikube, etc.) the easiest and quickest way is to simply delete the Minikube instance. To do so gracefully and easily, the recommended way is via:

```
minikube delete
```