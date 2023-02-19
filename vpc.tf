resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.0.0/18"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.64.0/18"

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.128.0/18"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.192.0/18"

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "main"
  }
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public2.id

  tags = {
    Name = "gw-NAT"
  }

}

resource "aws_route_table" "route_table_pub" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }



  tags = {
    Name = "example-public"
  }
}

resource "aws_route_table" "route_table_pri" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }



  tags = {
    Name = var.project1
  }
}

resource "aws_route_table_association" "ass" {
  subnet_id = aws_subnet.public1.id

  route_table_id = aws_route_table.route_table_pub.id
}

resource "aws_route_table_association" "ass_2" {
  subnet_id = aws_subnet.private1.id

  route_table_id = aws_route_table.route_table_pri.id
}

resource "aws_route_table_association" "ass3" {
  subnet_id = aws_subnet.public2.id

  route_table_id = aws_route_table.route_table_pub.id
}

resource "aws_route_table_association" "ass4" {
  subnet_id = aws_subnet.private2.id

  route_table_id = aws_route_table.route_table_pri.id
}
