# VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/18"

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "public01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public01"
  }
}

resource "aws_subnet" "public02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Public02"
  }
}

resource "aws_subnet" "private01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.32.0/20"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private01"
  }
}
resource "aws_subnet" "internal01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.48.0/21"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Internal01"
  }
}
resource "aws_subnet" "internal02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.56.0/21"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Internal02"
  }
}

resource "aws_internet_gateway" "ig1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# 3. Create Custom Route Table
resource "aws_route_table" "rt01" {
  vpc_id = aws_vpc.main.id

  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig1.id
  }

  tags = {
    "Name" = "rt01"
  }
}

resource "aws_route_table" "rt02" {
  vpc_id = aws_vpc.main.id
  route = []
  tags = {
    "Name" = "rt02"
  }
}

resource "aws_nat_gateway" "natg1" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private01.id

    tags = {
    Name = "Private NAT"
  }
}

resource "aws_route_table_association" "pub-rt01" {
  subnet_id      = aws_subnet.public01.id
  route_table_id = aws_route_table.rt01.id
}


resource "aws_route_table_association" "pub-rt02" {
  subnet_id      = aws_subnet.public02.id
  route_table_id = aws_route_table.rt01.id
}

resource "aws_route_table_association" "priv-rt01" {
  subnet_id      = aws_subnet.private01.id
  route_table_id = aws_route_table.rt02.id
}