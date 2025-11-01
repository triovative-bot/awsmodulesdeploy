module "vpc" {
  source = "../../modules/vpc"
  name   = var.name
  cidr   = var.vpc_cidr
  azs    = var.azs
  public_subnets_cidrs  = var.public_subnets_cidrs
  private_subnets_cidrs = var.private_subnets_cidrs
}


###======================================================================

# Security Group for EKS Cluster
resource "aws_security_group" "eks_sg" {
  name   = "eks-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-sg"
  }
}

module "eksfargate" {
  source = "../../modules/eksfargate"

  cluster_name       = var.name
  cluster_version    = "1.33"  # Changed from 1.33 (verify latest supported version)
  private_subnets    = module.vpc.private_subnets  # Common output name
  public_subnets     = module.vpc.public_subnets   # Common output name
  
  fargate_namespaces = ["default", "kube-system"]
  
  # Optional: Add tags if needed
  tags = {
    Environment = "production"
    Terraform   = "true"
  }
}

  # Alternative: If the above doesn't work, try:
  # private_subnets    = module.vpc.private_subnet_ids
  # public_subnets     = module.vpc.public_subnet_ids
  
  # Or if those don't work either:
  # private_subnets    = module.vpc.private_subnets[*].id
  # public_subnets     = module.vpc.public_subnets[*].id
  
