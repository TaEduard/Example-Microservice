# Example-Microservice

[How to guide](./How-to-setup-repo.md)

Create Kubernetes cluster in Azure, AWS or GCP, using Pulumi or Terraform:

1. Setup K8s cluster with the latest stable version, with RBAC enabled.
1. The Cluster should have 2 services deployed – Service A and Service B:
    1. Service A is a WebServer written in C#, Go or Python that exposes the following:
        1. Current value of Bitcoin in USD (updated every 10 seconds taken from an API on the web, like https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD).Average value over the last 10 minutes.
    1. Service B is a REST API service, which exposes a single controller that responds 200 status code on GET requests.
1. Cluster should have NGINX Ingress controller deployed, and corresponding ingress rules for Service A and Service B.
1. Service A should not be able to communicate with Service B.
