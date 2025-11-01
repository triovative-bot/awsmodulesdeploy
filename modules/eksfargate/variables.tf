############################################
# modules/eksfargate/variables.tf
############################################

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM role ARN for the EKS control plane"
  type        = string
}

variable "pod_execution_role_arn" {
  description = "IAM role ARN for Fargate pods"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS"
  type        = list(string)
}

variable "fargate_profiles" {
  description = "Map of Fargate profiles with subnet_ids and selectors"
  type = map(object({
    subnet_ids = list(string)
    selectors  = list(object({
      namespace = string
      labels    = optional(map(string))
    }))
  }))
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
