aws_region = "us-east-1"

vpc_name = "my-vpc"

vpc_cidr = "10.0.0.0/16"

environment = "dev"

public_subnet_cidrs = [
  "10.0.3.0/24",
]

private_subnet_cidrs = [
  "10.0.4.0/24",
]

owner = "DevOps-Team"

project = "terraform-vpc"