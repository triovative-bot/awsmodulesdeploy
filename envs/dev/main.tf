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

module "ec2" {
  source                 = "../../modules/ec2"
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = element(module.vpc.public_subnets, 0)
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

module "eks" {
  source          = "../../modules/eks"
  cluster_name    = "${var.name}-eks"
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
}
