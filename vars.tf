variable "REGION" {
  default = "ca-central-1"
}

variable "ZONE1" {
  default = "ca-central-1a"
}

variable "ZONE2" {
  default = "ca-central-1b"
}

variable "ZONE3" {
  default = "ca-central-1d"
}

variable "AMIS"{
    type = map(any)
    default = {
      amazonLinux = "ami-0d78d8707cd9c1be8"
      ubuntu22 = "ami-0ea18256de20ecdfc"
      ubuntu20= "ami-0940df33750ae6e7f"
      redhatLinux9= "ami-081650ae0104087a4"
    }
}

variable "AMAZONLINUX_USER" {
  default = "ec2-user"
}

variable "UBUNTU_USER"{
    default ="ubuntu"
}

variable "PRIVATE_KEY"{
    default = "summerskey"
}

variable "MY_IP"{
    default = "174.94.0.224/32"
}

variable "SUBNET_IDS" {
  type    = list(string)
  default = ["aws_subnet.summersPubSub1.id", "aws_subnet.summersPubSub2.id"]
}