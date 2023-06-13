resource "aws_vpc" "summersVpc" {
  cidr_block       = "172.22.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Vpc 1"
  }
}


resource "aws_subnet" "summersPublicSubnet1" {
  vpc_id     = aws_vpc.summersVpc.id
  cidr_block = "172.22.1.0/24"
  availability_zone = var.ZONE1

  tags = {
    Name = "Public subnet 1 of 2"
  }
}

resource "aws_subnet" "summersPublicSubnet2" {
  vpc_id     = aws_vpc.summersVpc.id
  cidr_block = "172.22.2.0/24"
  availability_zone = var.ZONE2

  tags = {
    Name = "Public subnet 2 of 2"
  }
}

resource "aws_subnet" "summersPrivateSubnet1" {
  vpc_id     = aws_vpc.summersVpc.id
  cidr_block = "172.22.3.0/24"
  availability_zone = var.ZONE1

  tags = {
    Name = "Private subnet 1 of 2"
  }
}

resource "aws_subnet" "summersPrivateSubnet2" {
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