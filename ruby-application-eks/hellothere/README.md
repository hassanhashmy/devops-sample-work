# README

This repository contains example applications for introducing GitOps implementation using Argo CD on top of Kubernetes.

The idea is having a Git repository that contains declarative descriptions of the infrastructure currently desired in the target environment and an automated process to make the environment match the described state in the repository.


## Project's layout
```
.
|-- Dockerfile
|-- LICENSE
|-- README.md
|-- apps
|   |-- awesomeapp-dev.yaml
|   `-- awesomeapp-prod.yaml
|-- charts
|   `-- awesomeapp-chart
`-- src
    |-- README.md
    `-- http_server.rb

4 directories, 7 files
```
> **Note**
>
> GitOps organizes the deployment process around code repositories as the central element. Usually, there are at least two repositories: `the application repository`, and `the environment repository`. But for simplicity, this project organizes them together as one.

| Folder | Description |
|--------|-------------|
| [apps](apps/) | Contains Argo CD Application manifests, each suffix with its own environment, e.g dev, prod|
| [charts/awesomeapp-chart](charts/awesomeapp-chart/) | Helm charts that will be deployed with Argo CD application manifests|
| [src](src/) | The application source code (the application repository)|
| [Dockerfile](Dockerfile) | Dockerfile uses to containerized the application |

## Changes may Require

| Files  | Description |
|--------|-------------|
| [apps/awesomeapp-dev.yaml](apps/awesomeapp-dev.yaml) | Line number 10 repo url
| [apps/awesomeapp-prod.yaml](apps/awesomeapp-prod.yaml) | Line number 10 repo url
| [charts/awesomeapp-chart/values.yaml/](charts/awesomeapp-chart/values.yaml) | Line number 4 repo name 



## Workflow

The deployment looks like the following steps:

- Changes to application source triggers build, test
- Merged requests trigger build and push image to a private registry (in this project, it's GitHub Package registry)
- Update environment repository with new Docker image tag in Helm Chart values
- Observe deployed application status, and sync

## Prerequisites

what you'll need?

- 2 CPUs or more
- 2 GB of free memory
- 20 GB of free disk space
- Internet connection
- A container runtime such as Docker or a virtual machine manager such VirtualBox was already installed in your local machine.

## Assumptions

There are assumptions made

### Audiences
Audiences who use this repository are familiar with:
- Source control management like Git
- Cloud Native applications
- GitOps
- Continuous Deployment
- Container Orchestration (Kubernetes)

### Platform
**Tested with**
- Ubuntu Linux 22.04
- Bash shell, version 5.x
- kubectl, version v1.25.0

## Local deployment

For a local deployment, we use `minikube` as the local Kubernetes, focus on making it easy to learn and develop for Kubernetes.

### Setup minikube

Step 1 - Installing minikube binary

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

Step 2 - Create a local Kubernetes cluster

From a terminal with administrator access (but not logged in as root), run

```
minikube start
```

### Setup Argo CD

Step 1 - Install argocd CLI

```
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

Step 2 - Install Argo CD

This will create a new namespace, argocd, where Argo CD services and application resources will live.

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Monitor Argo CD installation, and ensure all pods are ready

```bash
kubectl get pods --namespace argocd --watch
NAME                                                READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                     1/1     Running   0          3m49s
argocd-applicationset-controller-787bfd9669-7wb8p   1/1     Running   0          3m49s
argocd-dex-server-bb76f899c-jf7h5                   1/1     Running   0          3m49s
argocd-notifications-controller-5557f7bb5b-9j967    1/1     Running   0          3m49s
argocd-redis-b5d6bf5f5-6wk7q                        1/1     Running   0          3m49s
argocd-repo-server-56998dcf9c-z9h56                 1/1     Running   0          3m49s
argocd-server-5985b6cf6f-pl4b9                      1/1     Running   0          3m49s
```

Step 3 - Patch the Argo CD API Server

> **Notice**
> By default, the Argo CD API server is not exposed with an external IP. To access the API server, change service to to Load Balancer

Change the `argocd-server` service type to `LoadBalancer`:

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

Step 4 - Get API Server login URL

```bash
minikube service argocd-server --url --namespace argocd
http://192.168.49.2:32343
http://192.168.49.2:30113
```

You now can access to the API server using `http://192.168.49.2:32343`

Step 5 - Get Argo CD initial admin password

The initial password for the `admin` account is auto-generated and stored as clear text in the field `password` in a secret named `argocd-initial-admin-secret` in your Argo CD installation namespace. We can simple retrieve this password using the `argocd` CLI:

```bash
argocd admin initial-password -n argocd
```

### Create an application

Step 1 - Create a new app via UI

Go to Argo CD API server, click `+ NEW APP`

Step 2 - Update application content

Click `EDIT AS YAML`

Copy content of `apps/awesomeapp-dev.yaml` and paste in the content pane. And then click `SAVE`, and click `CREATE` to create a new application.

Once the application is created, you can now view its status via Argo CD UI.

### Build and push Docker images

Step 1 - Build a Docker image

At the root of the project, issue the following command:

```
docker build -t awesomeapp .
```

Step 2 - Login to your private registry

```bash
# Login to GitHub Package container registry
docker login --password <github token> --username <github_username> ghcr.io
```

Step 3 - Tag image

```bash
docker tag awesomeapp ghcr.io/<github_username>/awesomeapp
```

Step 4 - Push the Docker image to GitHub Package
```bash
docker push ghcr.io/<github_username>/awesomeapp
```
## References

- [argo CLI installation](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
- [Argo CD Getting started](https://argo-cd.readthedocs.io/en/stable/getting_started/)
- [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
