terraform {
  backend "s3" {
    bucket         = "aws-terraform-state-bucket01"
    key            = "aws-terraform-multiple-environments/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

