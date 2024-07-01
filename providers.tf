provider "aws" {
  region = var.region
}

data "aws_eks_cluster_auth" "auth" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}
# ###https://discuss.hashicorp.com/t/depends-on-in-providers/42632
# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   token                  = module.eks.cluster_token
#   load_config_file       = false
# }

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.auth.token
  }
}

terraform {
  backend "s3" {
    bucket         = "exmple-remote-state"
    key            = "default/default.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "example-remote-state-lock"
    profile        = "default"
    encrypt        = true
  }
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.12.1"
      configuration_aliases = [aws.this, aws.peer]
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.19.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }

  }
}