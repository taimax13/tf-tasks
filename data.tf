data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
  tags = {
    Tier = "Private"
  }
}

data "aws_eks_cluster_auth" "auth" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}