terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#############################################
# EKS Fargate Cluster - Main Configuration
#############################################

# Create IAM Role for EKS Control Plane
resource "aws_iam_role" "eks_cluster" {
  name = "${var.name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

# Attach EKS Cluster Policy
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "${var.name}-eks"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = {
    Name = "${var.name}-eks"
    Environment = var.environment
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

#############################################
# Fargate Pod Execution Role
#############################################

resource "aws_iam_role" "fargate_pod_execution_role" {
  name = "${var.name}-fargate-pod-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_execution_role_policy" {
  role       = aws_iam_role.fargate_pod_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

#############################################
# Fargate Profile
#############################################

resource "aws_eks_fargate_profile" "default" {
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "${var.name}-fargate-profile"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = var.fargate_namespace
  }

  tags = {
    Name = "${var.name}-fargate-profile"
    Environment = var.environment
  }

  depends_on = [
    aws_eks_cluster.this,
    aws_iam_role_policy_attachment.fargate_execution_role_policy
  ]
}

#############################################
# Optional: Label Namespace Automatically
#############################################

resource "null_resource" "label_namespace" {
  depends_on = [aws_eks_fargate_profile.default]

  provisioner "local-exec" {
    command = "kubectl label namespace ${var.fargate_namespace} eks.amazonaws.com/fargate-profile=${aws_eks_fargate_profile.default.fargate_profile_name} --overwrite || true"
  }
}
