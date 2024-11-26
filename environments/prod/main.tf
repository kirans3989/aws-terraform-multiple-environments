module "vpc" {
  source = "../../vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  environment        = var.environment
}

module "ec2" {
  source = "../../ec2"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnet_id
  vpc_id        = module.vpc.vpc_id
  instance_name = "${var.environment}-instance"
  environment   = var.environment
}

variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "availability_zone" {}
variable "environment" {}
variable "ami_id" {}
variable "instance_type" {}

output "instance_public_ip" {
  value = module.ec2.instance_public_ip
}
