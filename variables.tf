variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  description = "Name of the existing VPC"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "product" {
  description = "Product name"
  type        = string
}

variable "instance_types" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
  default     = ["m6i.large", "m6a.large", "m7g.large"]