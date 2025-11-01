
######################################
# variables.tf
######################################

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.33"
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs (optional for workloads needing public access)"
  type        = list(string)
  default     = []
}

variable "fargate_namespaces" {
  description = "List of Kubernetes namespaces to run on Fargate (private subnets)"
  type        = list(string)
  default     = ["default", "kube-system"]
}

