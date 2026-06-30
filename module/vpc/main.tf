# This Terraform configuration creates a VPC with public and private subnets, an internet gateway, a NAT gateway, and route tables for both public and private subnets. The configuration uses AWS as the provider and defines resources for the VPC, subnets, internet gateway, NAT gateway, route tables, and route table associations. The CIDR blocks for the VPC and subnets are specified in the local variables. The configuration also tags the resources for easier identification.
resource "aws_vpc" "my-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name        = var.vpc_name
    Environment = var.environment
    Owner       = var.owner
    Project     = var.project
  }
}
# availability zones are fetched usig data source
data "aws_availability_zones" "available" {
  state = "available"
}
# The following resources create public and private subnets in the VPC. The public subnet is configured to assign public IP addresses to instances launched in it, while the private subnet does not assign public IP addresses. The subnets are created in the availability zones fetched from the data source.
locals {
  public_subnet_cidr  = var.public_subnet_cidrs
  private_subnet_cidr = var.private_subnet_cidrs
}
resource "aws_subnet" "public-subnet" {
  count                   = length(local.public_subnet_cidr)
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = local.public_subnet_cidr[0]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "private-subnet" {
  count             = length(local.private_subnet_cidr)
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = local.private_subnet_cidr[0]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-igw"
  }
}
resource "aws_eip" "my-eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "my-nat-gateway" {
  count         = length(local.public_subnet_cidr)
  subnet_id     = aws_subnet.public-subnet[count.index].id
  allocation_id = aws_eip.my-eip.id
  depends_on    = [aws_internet_gateway.my-igw]
  tags = {
    Name = "my-nat-gateway-${count.index + 1}"
  }
}
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.my-vpc.id
  count  = length(local.public_subnet_cidr)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-nat-gateway[count.index].id

  }
  tags = {
    Name = "public-rt-${count.index + 1}"
  }
}
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.my-vpc.id
  count  = length(local.private_subnet_cidr)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-nat-gateway[count.index].id

  }
  tags = {
    Name = "private-rt-${count.index + 1}"
  }
}
resource "aws_route_table_association" "public-rt-association" {
  count          = length(local.public_subnet_cidr)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-rt[count.index].id
}
resource "aws_route_table_association" "private-rt-association" {
  count          = length(local.private_subnet_cidr)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-rt[count.index].id
}
