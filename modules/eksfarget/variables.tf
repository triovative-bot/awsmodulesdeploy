#############################################
# Input Variables for EKS Module
#############################################

variable "name" {
  description = "Base name for EKS resources"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "subnet_ids" {
  description = "List of subnet IDs where EKS and Fargate will run"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID associated with the EKS cluster"
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g. dev, prod)"
  type        = string
  default     = "prod"
}

variable "fargate_namespace" {
  description = "Kubernetes namespace that should use Fargate"
  type        = string
  default     = "default"
}
