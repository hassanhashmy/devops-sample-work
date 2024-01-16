# Host Multiple Applications on Amazon EKS Using a Single Application Load Balancer

AWS ALB helps implementing path-based routing (routing based in the Url path)  that allows to share multiple services through an endpoint. A client can use that endpoint to send requests to their desired service through the mentioned path and get desired responses.

This helps to demonstrate how to expose your applications that are running as containers and being orchestrated by Amazon EKS through an Application Load Balancer.

## Architecture and Components

**Amazon Elastic Kubernetes Service (Amazon EKS)** is a managed Kubernetes service that makes it easy for you to run Kubernetes on AWS and on-premises. Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications. Amazon EKS is certified Kubernetes-conformant, so existing applications that run on upstream Kubernetes are compatible with Amazon EKS.

**Amazon Fargate** is the serverless compute service for your applications. You do not have to do server management, scaling or patching, etc Just run your application, and pay for whatever you consume. when your applications stop, you stop paying as well.

**Amazon ECR** provides private registries so you can store your application's Docker comptiable images at any scale, and deploy them whenever you need.

**Application Load Balancer (ALB)** automatically distributes traffic between multiple targets such as EC2 instances, containers, or IP addresses in one or more Availability Zones.

**Ingress** is a Kubernetes resource that manage external access to the services in a cluster, typically HTTP. It usually provides load balancing, SSL, and virtual hosting. You will need to have an Ingress Controller in the cluster to enable Ingress features.

**AWS Load Balancer Controller** is a controller that helps manange Elastic Load Balancer for Kuberenetes clusters. The Ingress uses in this example will automatically provision an ALB and configure the routing rules needed for this ALB.

## Prerequisites

- **Terraform** installed. See the [Terraform install](https://developer.hashicorp.com/terraform/install) document for more information.
- **kubectl**. See [kubectl Install Tools document](https://kubernetes.io/docs/tasks/tools/) for more information.
- **aws cli** installed and configured. See the [Install AWS CLI document](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- **Docker** installed and configured. See the [Install Docker Engine document](https://docs.docker.com/engine/install/)

This assume you already configured AWS access keys with your machine environment. For more information, see the [Set up the AWS CLI document](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html)

## Environment creation

### Infrastructure

Create an infrastructure in AWS which includes:
- AWS VVPC
- An Amazon EKS cluster
- Private ECR repositories

1. Change to platform configuration directory

Change directory to `terraform/envs`

```
cd terraform/envs/
```

2. Prepare pre-settings for your environment

```
cp terraform.tfvars.example terraform.tfvars
```

3. Plan a apply

```
terraform plan
```

if encountering anything to prevent forwarding, fix it. And then plan again, until it succeeds.

4. Create the environment

To provision resources, run the following command

```
terraform apply -auto-approve
```

### Build and deploy

Build and deploy sample applications in `application/blue` and `application/orange`

1. Authorize against Amazon ECR private repository

```
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --out text)
export ECR_REPOSITORY=$ACCOUNT_ID.dkr.ecr.eu-west-2.amazonaws.com)

aws ecr get-login-password | docker --username AWS --password-stdin $ECR_REPOSITORY
```

2. Build `blue` application

From the root project directory, change to `blue/` directory

```
cd blue/
docker build -t $ECR_REPOSITORY/blue:develop .
```

3. Push `blue` Docker image to ECR

```
docker push $ECR_REPOSITORY/blue:develop
```

3. Build `orange` application

From the root project directory, change to `orange/` directory

```
cd orange/
docker build -t $ECR_REPOSITORY/orange:develop .
```

4. Push `orange` Docker image to ECR

```
docker push $ECR_REPOSITORY/orange:develop
```

### Test deployed applications

Deployed application be accessed via `/blue` or `/orange` routing path by visiting the Kubernetes ingress (AWS Load Balancer Controller).

Its DNS name can be obtained using the command:

```
kubectl get ingress app -o jsonpath={'.status.loadBalancer.ingress[0].hostname'}
```

Visiting `/orange` application should have result in

```
<h3 style="color: orange;">Orange</h3>
```

and `/blue` will have the following response

```
<h3 style="color: blue;">Blue</h3>
```

## Tear down

As you can see, creating an environment require minutes, and then you can deploy your applications quickly with confidence.

Once you are finished this, you can quickly tear down the whole recently created environment in the AWS to avoid charging for running resources.

Perform the following command inside `terraform/envs` directory

```
terraform destroy
```

While being asked, enter `yes` and press Enter to confirm.
