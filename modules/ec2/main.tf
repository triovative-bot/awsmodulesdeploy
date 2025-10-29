variable "ami" {}
variable "instance_type" { default = "t3.micro" }
variable "subnet_id" {}
variable "key_name" {}
variable "vpc_security_group_ids" { type = list(string) }

resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  associate_public_ip_address = true
  tags = { Name = "ec2-instance" }
}

output "instance_id" { value = aws_instance.this.id }
output "public_ip" { value = aws_instance.this.public_ip }
