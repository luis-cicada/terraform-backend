# Create Project VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Create Internet Gateway for VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# use data source to get all available AZs in the region
data "aws_availability_zones" "available" {}

# Create Public Subnets az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, 0)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-az1"
  }
}

# Create Public Subnets az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, 1)
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-az2"
  }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public_subnet_az1" {
  depends_on = [ aws_vpc.main, aws_subnet.public_subnet_az1, aws_subnet.public_subnet_az2, aws_route_table.public_route_table ]

  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az2" {
  depends_on = [ aws_vpc.main, aws_subnet.public_subnet_az1, aws_subnet.public_subnet_az2, aws_route_table.public_route_table ]

  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create Private Subnets az1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, 2)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-subnet-az1"
  }
}

# Create Private Subnets az2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, 3)
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-subnet-az2"
  }
}

# Create NAT Elastic IP Address
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

#Create NAT Gateway for Private Subnet
resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [ aws_eip.nat_eip ]

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }  
}

# Create Route Table for Private Subnets
resource "aws_route_table" "private_route_table" {
  depends_on = [ aws_nat_gateway.nat_gateway ]
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.project_name}-private-route-table"
  }
}

# Associate Private Subnets with Route Table
resource "aws_route_table_association" "private_subnet_az1" {
  depends_on = [ aws_vpc.main, aws_subnet.private_subnet_az1, aws_subnet.private_subnet_az2, aws_route_table.private_route_table ]

  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_az2" {
  depends_on = [ aws_vpc.main, aws_subnet.private_subnet_az1, aws_subnet.private_subnet_az2, aws_route_table.private_route_table ]

  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_route_table.id
}