output "vpc_id" {
  value = data.aws_vpc.existing.id
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_version" {
  value = module.eks.cluster_version
}
output "karpenter_irsa_arn" {
  value = module.karpenter.irsa_arn
}
output "karpenter_irsa_role_name" {
  value = module.karpenter.irsa_role_name
}