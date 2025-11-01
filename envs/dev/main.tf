module "vpc" {
  source = "../../modules/vpc"
  name   = var.name
  cidr   = var.vpc_cidr
  azs    = var.azs
  public_subnets_cidrs  = var.public_subnets_cidrs
  private_subnets_cidrs = var.private_subnets_cidrs
}

resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "eksfargate" {
  source = "../../modules/eksfargate"

  cluster_name           = var.name
  cluster_role_arn       = aws_iam_role.eks_cluster_role.arn
  pod_execution_role_arn = aws_iam_role.fargate_pod_role.arn
  private_subnet_ids     = module.vpc.private_subnets

  fargate_profiles = {
    default = {
      subnet_ids = module.vpc.private_subnets
      selectors = [
        {
          namespace = "default"
        },
        {
          namespace = "kube-system"
        }
      ]
    }
  }

  tags = {
    Environment = var.env
  }
}
