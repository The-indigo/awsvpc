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

variable "AMAZONLINUXUSER" {
  default = "ec2-user"
}

variable "UBUNTUUSER"{
    default ="ubuntu"
}