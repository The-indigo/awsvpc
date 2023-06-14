resource "aws_key_pair" "demoec2keypair"{
    key_name = "demoec2keypair"
    public_key = file("demokey.pub")
} 
resource "aws_instance" "summerswebserver" {
    ami = var.AMIS[ubuntu22]
    instance_type = "t2.micro"
    key_name = aws_key_pair.demoec2keypair.key_name
    vpc_security_group_ids = [aws.aws_security_group.summersSg]
    subnet_id = aws_subnet.summersPrivSub1.id
    tags = {
            Name    = "Summers web server"
            project = "Summers"
            Subnet = "Private"
    }
}

resource "aws_instance" "summersBastionHost" {
    ami = var.AMIS[ubuntu22]
    instance_type = "t2.micro"
    key_name = aws_key_pair.demoec2keypair.key_name
    vpc_security_group_ids = [aws.aws_security_group.summersElbSg]
    subnet_id = aws_subnet.summersPubSub1.id
    tags = {
            Name    = "Summers web server"
            project = "Summers"
            Subnet = "Private"
    }
}