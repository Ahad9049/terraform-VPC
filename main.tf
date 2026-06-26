provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }

}
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public-subnet"
  }
}
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private-subnet"
  }
}
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-igw"
  }
}
resource "aws_eip" "my-eip" {
  domain = aws_vpc.my-vpc.id
}
resource "aws_nat_gateway" "my-nat-gateway" {
  subnet_id = aws_subnet.public-subnet.id
  tags = {
    Name = "my-nat-gateway"
  }
}
resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-nat-gateway.id
  }
}
resource "aws_route_table_association" "my-route-table-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.my-route-table.id
}
output "vpc_id" {
  value = aws_vpc.my-vpc.id
}
output "public_subnet_id" {
  value = aws_subnet.public-subnet.id
}
output "private_subnet_id" {
  value = aws_subnet.private-subnet.id
}
output "nat_gateway_id" {
  value = aws_nat_gateway.my-nat-gateway.id
}