resource "aws_security_group" "summersSg" {
  name        = "summersSg"
  description = "Sec group for summers vpc"
  vpc_id      = aws_vpc.summersVpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "ssh"
    cidr_blocks      = [var.MY_IP]

  }

    ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "ssh"
    cidr_blocks      = [aws_instance.summersBastionHost.private_ip]

  }

      ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "http"
    cidr_blocks      = [aws_security_group.summersElbSg.id]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_security_group" "summersElbSg" {
  name        = "summersElbSg"
  description = "Sec group for summers Elastic load balancer "
  vpc_id      = aws_vpc.summersVpc.id

        ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "http"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}