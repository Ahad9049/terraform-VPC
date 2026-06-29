
resource "aws_vpc" "my-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "my-vpc"
    environment = "dev"
  }

}
data "aws_availability_zones" "available" {
  state = "available"
}
locals {
  public_subnet_cidr  = ["10.0.1.0/24"]
  private_subnet_cidr = ["10.0.10.0/24"]
}
resource "aws_subnet" "public-subnet" {
  count                   = length(local.public_subnet_cidr)
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = local.public_subnet_cidr[0]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "public-subnet${count.index + 1}"
  }
}
resource "aws_subnet" "private-subnet" {
  count             = length(local.private_subnet_cidr)
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = local.private_subnet_cidr[0]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "private-subnet${count.index + 1}"
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
  count = length(local.public_subnet_cidr) 
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
  count = length(local.private_subnet_cidr)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-nat-gateway[count.index].id

  }
  tags = {
    Name = "private-rt-${count.index + 1}"
  }
}
resource "aws_route_table_association" "public-rt-association" {
  count  = length(local.public_subnet_cidr)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-rt[count.index].id
}
resource "aws_route_table_association" "private-rt-association" {
  count  = length(local.private_subnet_cidr)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-rt[count.index].id
}
