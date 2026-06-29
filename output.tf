output "vpc_id" {
  value = aws_vpc.my-vpc.id
}
output "public_subnet_id" {
  value = aws_subnet.public-subnet[*].id
}
output "private_subnet_id" {
  value = aws_subnet.private-subnet[*].id
}
output "nat_gateway_id" {
  value = aws_nat_gateway.my-nat-gateway[*].id
}