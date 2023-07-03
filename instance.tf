resource "aws_key_pair" "summerskey" {
  key_name   = "summerskey"
  public_key = file("summerskey.pub")
}

resource "aws_instance" "summerswebserver" {
  ami                    = var.AMIS["ubuntu22"]
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.summerskey.key_name
  vpc_security_group_ids = [aws_security_group.summersSg.id]
  associate_public_ip_address = true
  subnet_id = aws_subnet.summersPrivSub1.id
  tags = {
    Name    = "Summers web server"
    project = "Summers"
    Subnet  = "Private"
  }
   user_data = file("userdata.sh")

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