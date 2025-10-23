resource "aws_vpc" "main" {
  cidr_block       = var.vpc
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = merge(
    var.vpc_tags,
    local.common_tags,
  {
    Name = local.common_name_suffix
  }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.igw_tags,
    local.common_tags,
  {
    Name = local.common_name_suffix
  }
  )
}

resource "aws_subnet" "subnet_public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.subnet_public_tags,
    local.common_tags,
  {
    Name = "${local.common_name_suffix}-public-${local.az_names[count.index]}"
  }
  )
}

resource "aws_subnet" "subnet_private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.subnet_private_tags,
    local.common_tags,
  {
    Name = "${local.common_name_suffix}-private-${local.az_names[count.index]}"
  }
  )
}

resource "aws_subnet" "subnet_database" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.subnet_database_tags,
    local.common_tags,
  {
    Name = "${local.common_name_suffix}-database-${local.az_names[count.index]}"
  }
  )
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id


  tags = merge(
    var.public_route_table_tags,
    local.common_tags,
  {
    Name = "${local.common_name_suffix}-public"
  }
  )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id


  tags = merge(
    var.private_route_table_tags,
    local.common_tags,
  {
    Name = "${local.common_name_suffix}-private"
  }
  )
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.main.id


  tags = merge(
    var.database_route_table_tags,
    local.common_tags,
  {
    Name = "${local.common_name_suffix}-database"
  }
  )
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_eip" "nat" {
    domain   = "vpc"

    tags = merge(
    var.eip_tags,
    local.common_tags,
  {
    Name = "${local.common_name_suffix}-nat"
  }
  )
}

resource "aws_nat_gateway" "NAT-Gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet_public[0].id

  tags = merge(
    var.nat_gateway_tags,
    local.common_tags,
  {
    Name = "${local.common_name_suffix}-nat_gateway"
  }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.NAT-Gateway.id
}

resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.NAT-Gateway.id
}

resource "aws_route_table_association" "public_association" {
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_association" {
  count = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.subnet_private[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "database_association" {
  count = length(var.database_subnet_cidr)
  subnet_id      = aws_subnet.subnet_database[count.index].id
  route_table_id = aws_route_table.database_route_table.id
}