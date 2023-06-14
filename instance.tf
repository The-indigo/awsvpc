resource "aws_key_pair" "summerskey"{
    key_name = "summerskey"
    public_key = file("summerskey.pub")
} 

resource "aws_instance" "summerswebserver" {
    ami = var.AMIS["ubuntu22"]
    instance_type = "t2.micro"
    key_name = aws_key_pair.summerskey.key_name
    vpc_security_group_ids = [aws_security_group.summersSg.id]

    subnet_id = aws_subnet.summersPrivSub1.id
    tags = {
            Name    = "Summers web server"
            project = "Summers"
            Subnet = "Private"
    }
      provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = var.UBUNTU_USER
    private_key = file(var.PRIVATE_KEY)
    host        = self.public_ip
  }
}

resource "aws_instance" "summersBastionHost" {
    ami = var.AMIS["ubuntu22"]
    instance_type = "t2.micro"
    key_name = aws_key_pair.summerskey.key_name
    vpc_security_group_ids = [aws_security_group.summersElbSg.id]
    subnet_id = aws_subnet.summersPubSub1.id
    tags = {
            Name    = "Summers web server"
            project = "Summers"
            Subnet = "Private"
    }
}