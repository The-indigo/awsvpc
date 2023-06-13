resource "aws_vpc" "vpc_v1" {
  cidr_block       = "172.22.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Vpc 1"
  }
}