# README

This repository contains example application deployment on aws using terraform. The repository contains different languages and different deployment strategy. Some of the folder contains CI/CD to deploy he applications. 


## Project's layout
```
.
|-- react-application
|-- ruby-application-eks

```


| Folder | Description |
|--------|-------------| 
| [aws-basic-challenge](aws-basic-challenge) | Contains exmaples how to access ec2 server with secure process, AWS IAM and AWS Shield implementation. AWS cloudwatch alerts and logs. 
| [aws-eb-ec2-stack](aws-eb-ec2-stack) | Terraform IaC to deploy AWS EB, ES, Redis, RDS. 
| [aws-eks-ec2-cluster](aws-eks-ec2-cluster) | Terraform IaC to deploy AWS EKS on EC2. 
| [python-serverless-application-lambda](python-serverless-application-lambda/) | Simple test python application to run on AWS lambda using aws api gateway. |
| [react-application](react-application/) |Simple test application to run on AWS S3, AWS Cloudfront, AWS IAM using terraform |
| [ruby-application-eks](ruby-application-eks) | Contains Argo CD Application manifests, each suffix with its own environment, Helm charts that will be deployed with Argo CD application manifests e.g dev, prod 


### Platform
**Tested with**
- Ubuntu Linux 22.04
- Bash shell, version 5.x
- kubectl, version v1.25.0


