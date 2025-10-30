variable "name" {
  description = "Name prefix for Fargate EKS resources"
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  default     = "1.29"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Fargate profile (can be public or private)"
  type        = list(string)
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
