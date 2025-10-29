output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS API endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "node_group_name" {
  description = "EKS node group name"
  value       = aws_eks_node_group.workers.node_group_name
}

output "cluster_role_arn" {
  description = "EKS IAM role ARN"
  value       = aws_iam_role.eks_cluster.arn
}
