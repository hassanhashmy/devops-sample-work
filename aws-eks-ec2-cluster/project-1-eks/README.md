
# Deploy AWS EKS Cluster and Services

This guideline will help you to follow steps to launch a new environment on AWS EKS with the help of ekctl and terraform. If you havn't setup your system before so this guide will explain steps to move forward and launch a successful environment. There are 2 major sections of this documentation, pre-requisites and deployment. In pre-requisites section you will setup your local setup for very first time. In deployment section you will actually moving forward to build and deploy new environment.

## Section 1: Pre-Requisites 
In this section will setup our local envornment first E.g git, ekctl, kubectl, aws. If you already setup any of the mentiobed below steps you can skip it as per your requirement or as per your need because if you setup already few things so you don't need to setup again.

### 1.1 Installation and configuration
This setup is valid for Ubuntu only and tested on `Ubuntu 20.04` but we can use `Ubuntu 21.04` as well. However, while writing this document we tested this on `Ubuntu 20.4` Make sure there is no error while installing and configureing by going through step by step. 

**Step 1 (Ubuntu Update):**
```
apt-get update -y
```
**Step 2 (Install some coomon packages):**
```
apt-get install net-tools wget curl git zip mlocate jq -y
```
**Step 3 (Git setup):**
```
mkdir /root/.ssh ; cd /root/.ssh/
```
- Create ssh public and private key and give it unique name to aboid any local overide. E.g I am saving the key with this name `/root/.ssh/github_ssh`
```
ssh-keygen
```
```
chmod 400 github_ssh; echo -e "Host github.com\nHostName github.com\nUser git\nIdentityFile ~/.ssh/github_ssh" > /root/.ssh/config
git config --global user.name "hashhash" ; git config --global user.email "hash@hash.holdings" 
ssh -T git@github.com
```
**Step 4 (AWS cli installation and setup):**
```
cd /root; curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"  \
unzip awscliv2.zip; sudo ./aws/install; mkdir .aws; cd .aws
```
- Now configure aws secret key and id with default region eu-west-2 (London)
```
aws configure
```
**Step 5 ([AWS IAM Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) installation and setup):**
```
cd /root
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
curl -o aws-iam-authenticator.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator.sha256
openssl sha1 -sha256 aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
aws-iam-authenticator help
```
**Step 6 (AWS EKS cli installation and setup):**
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```
**Step 7 (Kubernetes cli installation and setup):**
```
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
openssl sha1 -sha256 kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
kubectl version
```
**Step 8 ([Terraform](https://www.terraform.io/cli/install/apt) installation and setup):**
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform
terraform -install-autocomplete
source .bashrc
```


## Section 2: Deployment 
In this section will setup AWS EKS Cluster,Services and Monitoring. We will use terraform to deploy cluster, kubectl to deploy services and helm to deploy datadog monitoring. 

### 2.1 AWS EKS Cluster Provisioning and Deployment 
In this section firstly we will clone and edit code to provision cluster and then we willdeploy it.

### 2.1.1 Cloning & Editing
If we are creating new environment then we have to follow these steps

**Step 1 (New Branch & Cloning):** 
- Create new branch in git for new env like dev and clone it.
```
git clone git@github.com:hassanhashmy/devops.git; cd terraform; git checkout dev
```
- Copying previously used files of already created environment and renaming its state file or delete it.
```
cd terrafrom/terraform; cp -r staging development; cd development/api_v1
```
**Step 2 (Editing and Changes for new Environment):** 
This repo is a companion repo to the [Provision an EKS Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster), containing
Terraform configuration files to provision an EKS cluster on AWS.

- There are 4 main files to create AWS EKS cluster using terraform.
1. outputs.tf     is identical # This file will remain identical in all environments
2. kubernetes.tf  is identical # This file will remain identical in all environments
3. vpc.tf         update it # Update Cluster Name, VPC and Subnet CIDR to make it different from other VPC's.
4. eks-cluster.tf update it # Update tag Names

### 2.1.2 Deployment
In this sectio we are going to deploy resources after custom changes we made previously. Till now we havn't created any resources, we just made some changes.

**step 1 (deploy eks cluster):**
- Now we are going to deploy resources which includes VPC Netwrok Layer and AWS EKS cluster
```
terraform init
```
```
terraform apply
```
- Switch your kubectl context to point to the new cluster so that you can see details of eks cluster
```
aws eks update-kubeconfig --region $(terraform output -raw region)  --name $(terraform output -raw cluster_name)
```

**step 2 (deploy autoscaller):**
- Deploy - There are 2 ways to run kubectl apply command using directly weblink or by downloading the file and running it from local. But we have this file locally in source as well.
https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
```
curl -o cluster-autoscaler-autodiscover.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
kubectl apply -f cluster-autoscaler-autodiscover.yaml
```
Or use this same directly from link
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
```
**step 3 (annotate "not safe to evict"):**
```
kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
```

- Note: There is another command if required to run otherwise no need run. 
```
kubectl -n kube-system annotate serviceaccount cluster-autoscaler eks.amazonaws.com/role-arn=arn:aws:iam::<ACCOUNT_ID>:role/<AmazonEKSClusterAutoscalerRole>
```

**step 4 (edit the autoscaller deployment):**
- get the autoscaler image version
- open https://github.com/kubernetes/autoscaler/releases or https://github.com/kubernetes/autoscaler/releases?page=2 and get the latest release version matching your Kubernetes version, e.g. Kubernetes 1.14 => check for 1.14.n where "n" is the latest release version so k8s.gcr.io/autoscaling/cluster-autoscaler:v1.20.2
- edit deployment and set your EKS cluster name
```
kubectl -n kube-system edit deployment.apps/cluster-autoscaler
```
- set the image version at property `image=k8s.gcr.io/cluster-autoscaler:vx.yy.z` so `k8s.gcr.io/autoscaling/cluster-autoscaler:v1.20.2`
- set your EKS cluster name at the end of property `- --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/<<EKS cluster name>>`
- Maybe we don't need to go through above 2 points.
- view cluster autoscaler logs
```
kubectl -n kube-system logs deployment.apps/cluster-autoscaler
```
```
kubectl -n kube-system logs deployment.apps/cluster-autoscaler | grep -A5 "Expanding Node Group"
```
```
kubectl -n kube-system logs deployment.apps/cluster-autoscaler | grep -A5 "removing node"
```

The cluster autoscaler automatically launches additional worker nodes if more resources are needed, and shutdown worker nodes if they are underutilized. The autoscaling works within a nodegroup, hence create a nodegroup first which has this feature enabled.

**step 5 (scale the deployment):**
Not sure about this step so need to check

```bash
kubectl scale --replicas=3 deployment.apps/cluster-autoscaler
```

**step 6 (create a deployment of nginx and NLB):**

```
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.2/deploy/static/provider/aws/nlb-with-tls-termination/deploy.yaml
kubectl apply -f deploy.yaml
```
or same command as above
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.2/deploy/static/provider/aws/nlb-with-tls-termination/deploy.yaml
```
```
kubectl scale deployment ingress-nginx-controller -n ingress-nginx --replicas=3
```

**step 7 (deployment verification):**
- check pods
```
kubectl get pods -o wide --watch
```
- check nodes
```
kubectl get nodes
```

**step 8 (Kubernetes Dashboard):**
We are installing Kubernetes Dashboard v2 , which is still in beta state.
Main change: Heapster has been replaced by MetricsServer, to collect metrics
- Deploy the K8s Metrics Server

```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```
- Verification
```
kubectl get deployment metrics-server -n kube-system
```
- Deploy the K8s dashboard
- grab latest release of v2.xxx here: https://github.com/kubernetes/dashboard/releases

```
export DASHBOARD_RELEASE=v2.0.0-beta8
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/$DASHBOARD_RELEASE/aio/deploy/recommended.yaml
```
- create an admin user account however both files are same in repo but user is different `kubernetes-dashboard-admin.rbac.yaml` & 
`admin-service-account.yaml` so modify it or use same.

```
kubectl apply -f kubernetes-dashboard-admin.rbac.yaml
```
- access the dashboard
- get a security token

```
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep api-v1-stag-eks-admin | awk '{print $1}')
```
- record the output of `token:`
- start kube proxy via 
```
kubectl proxy
```
- If you are not able to run proxy and receiving error that already running so kill the process
```
ps aux | grep kubectl
```
- `root     11721  0.0  0.6 751864 48432 pts/1    Tl   11:31   0:00 kubectl proxy`
```
kill -9 11721
```
- open browser at `http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login`
- and choose _token_ as login method, where you have to provide the token you recorded two steps before
- This is just dashboard and doing nothing

**step 9 (RDS Database deployment):**
- Create a snapshot of you required db from which you wanted to create RDS or need data if you need otherwise create staging snapshot.
- Maybe we don't want to create db if we already have.
- If we need RDS so create it mannually as we don't have any automation for that. We are creating AWS Aurora PostgreSQL DB mannually.
- Get the Link of RDS and move forward.  Writer Instance Endpoint required.
- Attach proper security groups as well.

**step 10 (dopler token):**
- create a service token in doppler's new environment (dev) or with new name
- update values like db etc
- I updated only typeORM host and URL total 6 updates
- copy the service token and use this command to apply a new secret
```
kubectl create secret generic doppler-token --from-literal=DOPPLER_TOKEN=paste-toke-here
```

### 2.2 AWS EKS Service Provisiong and Deployment 
In this step we are going to provision and deploy services to AWS EKS cluster with `kubectl`. 

### 2.2.1 Cloning & Editing
If we are creating new environment then we have to follow these steps to allign with previous steps. Our service code is in eks folder
https://github.com/hassanhashmy/devops/tree/master/terraform/project-1-ekc/eks/development/api_v1

**Step 1 (Editing and Updating Names):** 
- Go to root of your project
```
cd terraform/project-1-ekc/eks/
```
```
cp -r staging development;  cd development/api_v1
```
- Now we have to update the environemnt name. if we copied from staging and wanted to create development so change the name by using below command
```
sed -i 's/staging/development/g' *
```

### 2.2.2 Deployment
In this sectio we are going to deploy resources after custom changes we made previously.

**Step 1 (Services Deployment):** 
- We can deploy all services using one command or we can deploy them one by one. Either we can pass folder name or just file name
```
kubectl apply -f microservices && kubectl apply -f cronjobs && kubectl apply -f frontends && kubectl apply -f networking     
```
```
kubectl apply -f cronjobs
kubectl apply -f frontends
kubectl apply -f microservices
kubectl apply -f networking
```
- Both abpve commands are doing same job. However if we are updying only one service so pass the complete path with file name like `kubectl apply -f networking/ingress-srv.yaml`
- If there is no Kubernetes version problem, so this setup will run smoothly

**Step 2 (DNS Name):** 
- Now we have to add entries to DNS get the elb link and go to cloudflare
- Add 3 subdomains and change the values as mentioned below with cname value like mentioned below. Please check your elb link and replace it. 

1. `api-v1-development-eks` -> xxxxxxxxxxxxxxxxxxx.elb.eu-west-2.amazonaws.com
2. `hash-eco-status-development` -> xxxxxxxxxxxxxxxxxxxxxxxx.elb.eu-west-2.amazonaws.com
3. `development-pay` -> xxxxxxxxxxxxxxxxxxxxxx.elb.eu-west-2.amazonaws.com

**Step 3 (Pipeline Setup):** 
- If it is brand new environemnt then we will require pipline setup as well. We need to create few files in each repository of our application.
- Create branch from you required source of branch on enviornment you wanted to follow and checkout into it.
```
git checkout api_v1-development
```
```
cd .github/workflows
```
- Copy a file from staging or production having pull word in it which means run pipelin on pull request. Update the file name as mentioned below.
```
cp test-pull_request-service1-to-hash-cron-api_v1-staging.yml  test-pull_request-service1-to-hash-cron-api_v1-development.yml
```
- Above file will run piplein and run tests.
- Now we need to create another file which will basciall be used to deploy the updated code and container to service.
```
cp deploy-service1-to-hash-cron-api_v1-staging.yml deploy-service1-to-hash-cron-api_v1-development.yml 
```
- Now change the name using below command in the file and use same name of your cluster as you created and check name of services.
```
sed -i 's/staging/development/g'  deploy-service1-api_v1-development.yml
```
- Now commit your changes and push them into branch and create a PR for master.
```
git add.
git commit -m"Dev env pipline added development"
gt push
```
- Repeat this step for each service repo.

### 2.3 AWS EKS Datadog Monitoring 
In this sub section we are adding monitoring.  

**Step 1 (Helm Configuration):** 

- install helm  https://v3.helm.sh/docs/intro/install/
- Navigate root of your project
```
cd terraform/project-1-eks/terrafrom/development/api_v1
```
- Download the file if you don't have `curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3`
```
chmod 700 get_helm.sh
./get_helm.sh
```
- Add datadog repo
```
helm repo add datadog https://helm.datadoghq.com
helm repo update
```
- Get api key from datadog portal and give proper name  https://app.datadoghq.eu/organization-settings/api-keys?sort=created_at&sort_dir=asc
- Update the cluster name and api key value in `values.yaml`

```
cd devops/terraform/project-1-eks/eks/development/api_v1/monitoring
```
```
helm install datadog -f values.yaml  --set datadog.site=datadoghq.eu --set datadog.apiKey=yourApikKey datadog/datadog --set targetSystem=linux
helm install stable -f  values.yaml  --set datadog.site=datadoghq.eu --set datadog.apiKey=yourApikKey datadog/datadog --set targetSystem=linux

```
```
helm upgrade datadog -f values.yaml --set datadog.site=datadoghq.eu --set datadog.apiKey=yourApikKey datadog/datadog --set targetSystem=linux
helm upgrade stable -f  values.yaml --set datadog.site=datadoghq.eu --set datadog.apiKey=yourApikKey datadog/datadog --set targetSystem=linux
```
- To remove datadog follow the below commands
```
helm delete datadog
helm delete stable
```

## Traffic Distribution in EKS
This detail is provided by AWS.
NLB < Load Balancing > underlying worker node's nodeport/targetport <Load Balancing> *kube-proxy* <> nginx controller pod <> kube-proxy < Load Balancing > your applicaiton pods
NLB < Load Balancing > underlying worker node's nodeport/targetport <> *kube-proxy directs straight if underlying worker node has the nginx pod* <> nginx controller pod <> kube-proxy <Load Balancing> your applicaiton pods

