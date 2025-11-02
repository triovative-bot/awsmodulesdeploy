terraform {
  backend "s3" {
    bucket         = "trio-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}



#terraform {
#  backend "local" {
#    path = "terraform.tfstate"
#  }
#}
