resource "aws_vpc" "task_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "task-vpc"
  }
}
data "aws_availability_zones" "available" {}
# Public Subnets for Load Balancer and NAT Gateway
resource "aws_subnet" "task_public_subnet" {
  count      = 2
  vpc_id     = aws_vpc.task_vpc.id
  cidr_block = cidrsubnet(aws_vpc.task_vpc.cidr_block, 8, count.index)

  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "task-public-subnet-${count.index + 1}"
  }
}

# Private Subnets for Worker Nodes
/**
resource "aws_subnet" "task_private_subnet" {
  count      = 2
  vpc_id     = aws_vpc.task_vpc.id
  cidr_block = cidrsubnet(aws_vpc.task_vpc.cidr_block, 8, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "task-private-subnet-${count.index + 1}"
  }
}
**/
resource "aws_internet_gateway" "task_igw" {
  vpc_id = aws_vpc.task_vpc.id
}

resource "aws_route_table" "task_public_route_table" {
  vpc_id = aws_vpc.task_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.task_igw.id
  }

  tags = {
    Name = "task-public-route-table"
  }
}

resource "aws_route_table_association" "task_public_subnet_assoc" {
  count          = 2
  subnet_id      = aws_subnet.task_public_subnet[count.index].id
  route_table_id = aws_route_table.task_public_route_table.id
}

# NAT Gateway in public subnet for private subnets
resource "aws_eip" "task_nat_eip" {
  domain = "vpc"  # Updated to use the domain attribute
}
/**
resource "aws_nat_gateway" "task_nat_gateway" {
  allocation_id = aws_eip.task_nat_eip.id
  subnet_id     = aws_subnet.task_public_subnet[0].id
}

resource "aws_route_table" "task_private_route_table" {
  vpc_id = aws_vpc.task_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.task_nat_gateway.id
  }

  tags = {
    Name = "task-private-route-table"
  }
}

resource "aws_route_table_association" "task_private_subnet_assoc" {
  count          = 2
  subnet_id      = aws_subnet.task_private_subnet[count.index].id
  route_table_id = aws_route_table.task_private_route_table.id
}
**/
