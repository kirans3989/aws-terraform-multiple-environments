provider "aws" {
  region = "us-east-1"
}
 backend "s3" {
    bucket = "aws-terraform-state-bucket01"
    key    = "terraform-state/multi-env"
    region = "us-east-1"
  }
}
