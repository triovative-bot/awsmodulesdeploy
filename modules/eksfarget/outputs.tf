#############################################
# Outputs for EKS Module
#############################################

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority" {
  description = "EKS cluster certificate authority data"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "fargate_profile_name" {
  description = "Name of the created Fargate profile"
  value       = aws_eks_fargate_profile.default.fargate_profile_name
}

output "fargate_pod_role_arn" {
  description = "ARN of the Fargate pod execution role"
  value       = aws_iam_role.fargate_pod_execution_role.arn
}
