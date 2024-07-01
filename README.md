# tf-tasks Repository

This repository demonstrates the flexibility of building infrastructure using Terraform. It allows customization based on product, environment, and other variables.

This setup:
1. Deploys an EKS cluster into an existing VPC.
2. Uses Karpenter with node pools that can deploy both x86 and ARM64 (Graviton) instances.
3. Includes a README that explains how to use the Terraform repo and demonstrates how to run pods on x86 or Graviton instances.
4. Includes a `terraform.tfvars` file to pass variables like `vpc_name`, `env`, and `product`.

Users can customize the variables in the `terraform.tfvars` file to match their specific environment and requirements.

## EKS Cluster with Karpenter Autoscaler

This Terraform configuration deploys an Amazon EKS cluster with Karpenter for efficient autoscaling across x86 and ARM64 (Graviton) instances in an existing VPC.

## Prerequisites

- AWS CLI configured with appropriate credentials.
- Terraform installed (version 1.0.0 or later).
- kubectl installed.

## Usage

### Note: The `instance_types` variable uses default values. If you want to override these, you can add the following line to your `terraform.tfvars`:

1. Clone this repository:

    ```bash
    git clone https://github.com/taimax13/tf-tasks.git && cd <repository-directory>
    ```

2. Modify `terraform.tfvars` with your specific values and rename based on the product/env of your choice to avoid duplications:

    ```hcl
    region    = "your-aws-region"
    vpc_name  = "your-existing-vpc-name"
    env       = "your-environment"
    product   = "your-product-name"
    ```

3. Initialize Terraform:

    ```bash
    terraform init
    ```

4. Review the planned changes:

    ```bash
    terraform plan -var-file=<your-renamed>.tfvars
    ```

5. Apply the configuration:

    ```bash
    terraform apply -var-file=<your-renamed>.tfvars
    ```

6. After a successful apply, configure kubectl:

    ```bash
    aws eks --region $(terraform output region) update-kubeconfig --name $(terraform output cluster_name)
    ```

## Running Pods on x86 or Graviton Instances

To run your pods on specific architectures, use node selectors in your Kubernetes manifests.

### Example: Running on x86

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-x86-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-x86-app
  template:
    metadata:
      labels:
        app: my-x86-app
    spec:
      nodeSelector:
        kubernetes.io/arch: amd64
      containers:
      - name: my-app
        image: my-x86-image:latest

### Example: Running on ARM64 (Graviton)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-arm-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-arm-app
  template:
    metadata:
      labels:
        app: my-arm-app
    spec:
      nodeSelector:
        kubernetes.io/arch: arm64
      containers:
      - name: my-app
        image: my-arm-image:latest```    

#####

kubectl apply -f <manifest-file>.yaml or fit it in your helm templates


Karpenter will automatically provision the appropriate instance type based on the nodeSelector.
Tips:

    Use multi-arch images when possible to support both architectures.
    Monitor costs and performance to optimize your workload distribution.
    Use kubectl get nodes -L kubernetes.io/arch to view the architecture of your nodes.

### If you'll have comments/suggestions or any other feedback, please feel free to reach out to me or create an issue.