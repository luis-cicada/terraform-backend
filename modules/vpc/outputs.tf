output "region" {
  value = var.aws_region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "private_subnet_az1_id" {
  value = aws_subnet.private_subnet_az1.id
}

output "private_subnet_az2_id" {
  value = aws_subnet.private_subnet_az2.id
}

output "nat_gateway_ip" {
  value = aws_eip.nat_eip.public_ip
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
  
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}
