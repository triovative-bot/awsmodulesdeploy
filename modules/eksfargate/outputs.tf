variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs (not used directly in EKS but available for reference)"
  type        = list(string)
  default     = []
}

variable "fargate_namespaces" {
  description = "List of namespaces to run on Fargate"
  type        = list(string)
  default     = ["default", "kube-system"]
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
