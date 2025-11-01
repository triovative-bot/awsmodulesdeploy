############################################
# modules/eksfargate/main.tf
############################################

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  tags = merge(var.tags, {
    "Name" = var.cluster_name
  })
}

# Create Fargate profiles
resource "aws_eks_fargate_profile" "default" {
  for_each = var.fargate_profiles

  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = each.key
  pod_execution_role_arn = var.pod_execution_role_arn
  subnet_ids             = each.value.subnet_ids
  selectors              = each.value.selectors

  tags = merge(var.tags, {
    "FargateProfile" = each.key
  })
}
