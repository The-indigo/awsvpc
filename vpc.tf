resource "aws_vpc" "summersVpc" {
  cidr_block       = "172.22.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Vpc 1"
  }
}


resource "aws_subnet" "summersPubSub1" {
  vpc_id     = aws_vpc.summersVpc.id
  cidr_block = "172.22.1.0/24"
  availability_zone = var.ZONE1

  tags = {
    Name = "Public subnet 1 of 2"
  }
}

resource "aws_subnet" "summersPubSub2" {
  vpc_id     = aws_vpc.summersVpc.id
  cidr_block = "172.22.2.0/24"
  availability_zone = var.ZONE2

  tags = {
    Name = "Public subnet 2 of 2"
  }
}

resource "aws_subnet" "summersPrivSub1" {
  vpc_id     = aws_vpc.summersVpc.id
  cidr_block = "172.22.3.0/24"
  availability_zone = var.ZONE1
  tags = {
    Name = "Private subnet 1 of 2"
  }
}

resource "aws_subnet" "summersPrivSub2" {
  vpc_id     = aws_vpc.summersVpc.id
  cidr_block = "172.22.4.0/24"
  availability_zone = var.ZONE2

  tags = {
    Name = "Private subnet 2 of 2"
  }
}

resource "aws_internet_gateway" "summersVpcIG" {
  vpc_id = aws_vpc.summersVpc.id
}

resource "aws_route_table" "summersRouteTable" {
  vpc_id = aws_vpc.summersVpc.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.summersVpcIG.id
  }

  tags = {
    Name = "Summers public subnet route table"
  }
}

resource "aws_route_table_association" "summersPubSubAssoc1" {
  subnet_id      = aws_subnet.summersPubSub1.id
  route_table_id = aws_route_table.summersRouteTable.id
}

resource "aws_route_table_association" "summersPubSubAssoc2" {
  subnet_id      = aws_subnet.summersPubSub2.id
  route_table_id = aws_route_table.summersRouteTable.id
}
