# gcp-kubernetes-canary-gitops-demo

This repository contains IaC code to setup a Kubernetes cluster with Terraform and perform canary releases using Istio and Flux/Flagger

```sh
export GITHUB_TOKEN=xxx
export GOOGLE_APPLICATION_CREDENTIALS=xxx
```

## Load Test

```sh
curl -L https://goo.gl/S1Dc3R | bash -s 20 "http://server.com/api"
```
