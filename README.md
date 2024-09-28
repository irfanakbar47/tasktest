# tasktest

Task Completion Steps
# Task Completion Steps

## 1. AWS Configuration

First, run the following command to configure AWS CLI with your profile details:

```bash
aws configure

You will be prompted to enter:

AWS Access Key ID
AWS Secret Access Key
Default region name (for example, eu-north-1 to use t3.micro instances in the free tier, adjust according to your region requirements).


## 2. EKS Infrastructure Setup
To create the EKS infrastructure, follow these steps:

    1- Go to the Terraform directory:
        ```bash
   
          terraform init
          terraform plan
          terraform aply

## 3. Kubernetes Cluster Setup

    1- Update your local kubeconfig to interact with the newly created EKS cluster:
          ```bash
             aws eks update-kubeconfig --name task-eks-cluster

    2- Install Ingress-NGINX to control traffic within the cluster:

        Download the NGINX deployment file:
        ```bash
            kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

    3- Apply all the Kubernetes deployments from the kubernetes folder:
        ```bash
            kubectl apply -f kubenetes/ .



