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