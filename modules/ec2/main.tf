# Input variables
variable "ami" {}
variable "instance_type" { default = "t3.micro" }
variable "subnet_id" {}
variable "key_name" {}
variable "vpc_security_group_ids" { type = list(string) }

# Optional: Whether to create a new key automatically
variable "create_new_key" {
  description = "If true, Terraform will generate a new SSH key pair"
  type        = bool
  default     = true
}

# Create new key if enabled
resource "tls_private_key" "this" {
  count     = var.create_new_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  count      = var.create_new_key ? 1 : 0
  key_name   = var.key_name
  public_key = tls_private_key.this[0].public_key_openssh
}

# Save private key locally
resource "local_file" "private_key_pem" {
  count    = var.create_new_key ? 1 : 0
  content  = tls_private_key.this[0].private_key_pem
  filename = "${path.module}/${var.key_name}.pem"
}

# EC2 instance creation
resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.create_new_key ? aws_key_pair.this[0].key_name : var.key_name
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = true

  tags = {
    Name = "public-ec2"
  }
}

# Outputs
output "instance_id"  { value = aws_instance.this.id }
output "public_ip"    { value = aws_instance.this.public_ip }
output "private_ip"   { value = aws_instance.this.private_ip }

# Output private key path (optional for debugging)
output "private_key_file" {
  value       = var.create_new_key ? local_file.private_key_pem[0].filename : null
  description = "Path to the private key PEM file (only when create_new_key=true)"
}
