resource "aws_key_pair" "summerskey" {
  key_name   = "summerskey"
  public_key = file("summerskey.pub")
}

resource "aws_instance" "summerswebserver" {
  ami                    = var.AMIS["ubuntu22"]
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.summerskey.key_name
  vpc_security_group_ids = [aws_security_group.summersSg.id]

  subnet_id = aws_subnet.summersPrivSub1.id
  tags = {
    Name    = "Summers web server"
    project = "Summers"
    Subnet  = "Private"
  }
   user_data = <<-EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install wget apache2 unzip -y
sudo systemctl start apache2
sudo systemctl enable apache2
wget https://www.tooplate.com/zip-templates/2117_infinite_loop.zip
unzip -o 2117_infinite_loop.zip
cp -r 2117_infinite_loop/* /var/www/html
systemctl restart apache2
  EOF
  connection {
    user        = var.UBUNTU_USER
    private_key = file(var.PRIVATE_KEY)
    host        = self.public_ip
  }
}

resource "aws_instance" "summersBastionHost" {
  ami                    = var.AMIS["ubuntu22"]
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.summerskey.key_name
  vpc_security_group_ids = [aws_security_group.summersElbSg.id]
  subnet_id              = aws_subnet.summersPubSub1.id
  associate_public_ip_address = true
  tags = {
    Name    = "Summersbastionhost"
    project = "Summers"
    Subnet  = "Public"
  }
}