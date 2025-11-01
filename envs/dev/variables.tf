variable "region" { default = "us-east-1" }
variable "name" { default = "prod" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "azs" { default = ["us-east-1a","us-east-1b"] }
variable "public_subnets_cidrs" { default = ["10.0.1.0/24","10.0.2.0/24"] }
variable "private_subnets_cidrs" { default = ["10.0.101.0/24","10.0.102.0/24"] }
variable "admin_cidr" { default = "0.0.0.0/0" }
variable "ec2_ami" { default = "ami-0c94855ba95c71c99" }
variable "ec2_instance_type" { default = "t3.micro" }
variable "ssh_key_name" { default = "my-key" }
variable "aws_region" { default = "ap-south-1" }
variable "aws_access_key" { sensitive   = true }
variable "aws_secret_key" { sensitive   = true }
# Add these to your existing variables.tf

variable "cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.28"
}

# Note: You have duplicate region variables - consider consolidating
# Remove one of these:
# variable "region" { default = "us-east-1" }
# variable "aws_region" { default = "ap-south-1" }

# Keep only one:
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}
