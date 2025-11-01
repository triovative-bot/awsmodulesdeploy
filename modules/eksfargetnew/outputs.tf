######################################
# outputs.tf
######################################

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS API endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_role_arn" {
  description = "EKS IAM role ARN"
  value       = aws_iam_role.eks_cluster.arn
}

output "fargate_profile_private_name" {
  description = "Name of the private Fargate profile"
  value       = aws_eks_fargate_profile.private.fargate_profile_name
}

output "fargate_profile_public_name" {
  description = "Name of the public Fargate profile (if created)"
  value       = try(aws_eks_fargate_profile.public[0].fargate_profile_name, null)
}
