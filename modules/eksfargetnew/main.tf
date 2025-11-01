######################################
# main.tf
######################################

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --------------------------------------------
# IAM Role for EKS Cluster
# --------------------------------------------
data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster" {
  name               = "${var.cluster_name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# --------------------------------------------
# EKS Cluster
# --------------------------------------------
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.private_subnets
  }

  version = var.cluster_version

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# --------------------------------------------
# IAM Role for Fargate Profile
# --------------------------------------------
data "aws_iam_policy_document" "fargate_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "fargate_pod_execution_role" {
  name               = "${var.cluster_name}-fargate-pod-role"
  assume_role_policy = data.aws_iam_policy_document.fargate_assume_role.json
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_execution_role.name
}

# --------------------------------------------
# EKS Fargate Profiles (private + optional public)
# --------------------------------------------
# Default Fargate profile for private workloads
resource "aws_eks_fargate_profile" "private" {
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "${var.cluster_name}-fargate-private"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = var.private_subnets

  dynamic "selector" {
    for_each = var.fargate_namespaces
    content {
      namespace = selector.value
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.fargate_pod_execution_role_policy
  ]
}

# Optional public namespace profile
resource "aws_eks_fargate_profile" "public" {
  count                  = length(var.public_subnets) > 0 ? 1 : 0
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "${var.cluster_name}-fargate-public"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = var.public_subnets

  selector {
    namespace = "public"
  }

  depends_on = [
    aws_iam_role_policy_attachment.fargate_pod_execution_role_policy
  ]
}
