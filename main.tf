resource "aws_vpc" "summersVpc" {
  cidr_block       = "172.22.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "Vpc 1"
  }
}


resource "aws_subnet" "summersPubSub1" {
  vpc_id            = aws_vpc.summersVpc.id
  cidr_block        = "172.22.1.0/24"
  availability_zone = var.ZONE1
  map_public_ip_on_launch = true 
  tags = {
    Name = "Public subnet 1 of 2"
  }
}

resource "aws_subnet" "summersPubSub2" {
  vpc_id            = aws_vpc.summersVpc.id
  cidr_block        = "172.22.2.0/24"
  availability_zone = var.ZONE2
  map_public_ip_on_launch = true 

  tags = {
    Name = "Public subnet 2 of 2"
  }
}

resource "aws_subnet" "summersPrivSub1" {
  vpc_id            = aws_vpc.summersVpc.id
  cidr_block        = "172.22.3.0/24"
  availability_zone = var.ZONE1
  tags = {
    Name = "Private subnet 1 of 2"
  }
}

resource "aws_subnet" "summersPrivSub2" {
  vpc_id            = aws_vpc.summersVpc.id
  cidr_block        = "172.22.4.0/24"
  availability_zone = var.ZONE2

  tags = {
    Name = "Private subnet 2 of 2"
  }
}

resource "aws_internet_gateway" "summersVpcIG" {
  vpc_id = aws_vpc.summersVpc.id
}

resource "aws_route_table" "summersPubRouteTable" {
  vpc_id = aws_vpc.summersVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.summersVpcIG.id
  }

  tags = {
    Name = "Summers internet access route table"
  }
}


resource "aws_route_table_association" "summersPubSubAssoc1" {
  subnet_id      = aws_subnet.summersPubSub1.id
  route_table_id = aws_route_table.summersPubRouteTable.id
}

resource "aws_route_table_association" "summersPubSubAssoc2" {
  subnet_id      = aws_subnet.summersPubSub2.id
  route_table_id = aws_route_table.summersPubRouteTable.id
}

resource "aws_eip" "summersEip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.summersVpcIG]
}


resource "aws_nat_gateway" "summersNg" {
  allocation_id = aws_eip.summersEip.id
  subnet_id     = aws_subnet.summersPubSub1.id


  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.summersVpcIG]
}

resource "aws_route_table" "summersPrivRouteTable" {
  vpc_id = aws_vpc.summersVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.summersNg.id
  }

  tags = {
    Name = "Summers private subnet route table"
  }
}

resource "aws_route_table_association" "summersPrivSubAssoc1" {
  subnet_id      = aws_subnet.summersPrivSub1.id
  route_table_id = aws_route_table.summersPrivRouteTable.id
}

resource "aws_route_table_association" "summersPrivSubAssoc2" {
  subnet_id      = aws_subnet.summersPrivSub2.id
  route_table_id = aws_route_table.summersPrivRouteTable.id
}


resource "aws_lb" "summersLb" {
  name                       = "summersLb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.summersElbSg.id]
  subnets            = [aws_subnet.summersPubSub1.id,aws_subnet.summersPubSub2.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "summersLbTg" {
  name     = "summersLbTg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.summersVpc.id
    health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 70
    matcher             = "200,202"
    port                = 80
    path                = "/"
    protocol            = "HTTP"
    timeout             = 40
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "summersTgAttachment" {
  target_group_arn = aws_lb_target_group.summersLbTg.arn
  target_id        = aws_instance.summerswebserver.id
  port             = 80
}

resource "aws_lb_listener" "summersLbListener" {
  load_balancer_arn = aws_lb.summersLb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.summersLbTg.arn
  }
}