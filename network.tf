resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = local.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = local.tags
}

resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on = [ aws_internet_gateway.igw ]
  tags = local.tags
}

resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.zones.names[0]
  map_public_ip_on_launch = true
  tags = local.tags
}

resource "aws_subnet" "private_subnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.zones.names[0]
  map_public_ip_on_launch = false
  tags = local.tags
}

resource "aws_subnet" "private_subnet_2" {
  cidr_block = "10.0.3.0/24"
  vpc_id     = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.zones.names[0]
  map_public_ip_on_launch = false
  tags = local.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = local.tags
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = local.tags
}

resource "aws_route" "public_igw" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "private_nat" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public_assoc" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public_subnet.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}

data "aws_availability_zones" "zones" {
  filter {
    name   = "region-name"
    values = [ var.region ]
  }
}
