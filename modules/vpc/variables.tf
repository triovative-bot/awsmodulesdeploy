variable "name" {}
variable "cidr" {}
variable "azs" { type = list(string) }
variable "public_subnets_cidrs" { type = list(string) }
variable "private_subnets_cidrs" { type = list(string) }
