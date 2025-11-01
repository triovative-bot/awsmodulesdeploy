############################################
# modules/eksfargate/outputs.tf
############################################

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "fargate_profile_names" {
  value = [for p in aws_eks_fargate_profile.default : p.fargate_profile_name]
}
