apiVersion: projectriff.io/v1
kind: Topic
metadata:
  name: counter
---

apiVersion: projectriff.io/v1
kind: Function
metadata:
  name: counter
spec:
  protocol: http
  input: counter
  container:
    image: projectriff/counter:0.0.1