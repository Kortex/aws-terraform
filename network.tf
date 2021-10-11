resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = local.tags
}

resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.region_zones.names[0]
  map_public_ip_on_launch = true
  vpc_id     = aws_vpc.vpc.id

  tags = local.tags
}

resource "aws_subnet" "private_subnet" {
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.region_zones.names[0]
  map_customer_owned_ip_on_launch = false
  vpc_id     = aws_vpc.vpc.id
}

resource "aws"

data "aws_availability_zones" "region_zones" {

  filter {
    name   = "region-name"
    values = [ var.region ]
  }

}
