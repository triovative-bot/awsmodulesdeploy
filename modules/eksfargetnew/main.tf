resource "aws_iam_role" "eks_fargate" {
  name = "${var.name}-fargate-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_policy" {
  role       = aws_iam_role.eks_fargate.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

resource "aws_eks_cluster" "this" {
  name     = "${var.name}-fargate"
  role_arn = aws_iam_role.eks_fargate.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [aws_iam_role_policy_attachment.fargate_policy]
}

resource "aws_eks_fargate_profile" "this" {
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "${var.name}-profile"
  pod_execution_role_arn = aws_iam_role.eks_fargate.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = "default"
  }

  depends_on = [aws_eks_cluster.this]
}
