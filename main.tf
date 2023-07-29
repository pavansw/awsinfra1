## VPC Creation
resource "aws_vpc" "myvpc" {
instance_tenancy = "default"
cidr_block = "100.100.0.0/16"
tags = {
      Name = "Pavan-VPC"
    }
}

## Internet gateway
resource "aws_internet_gateway" "mygw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "Pavan-GW"
  }
}


##  Subnet on one AZ
resource "aws_subnet" "mysubnets" {
vpc_id = aws_vpc.myvpc.id
cidr_block = "100.100.1.0/24"
availability_zone = "ap-south-1b"

  tags = {
    Name = "Pavan-VPC-Subnet"
  }
}

## Route Table
resource "aws_route_table" "myroute1"{
vpc_id = aws_vpc.myvpc.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.mygw.id
}
}

##  Route table association with subnet

resource "aws_route_table_association" "myroute_asso"{
        subnet_id = aws_subnet.mysubnets.id
        route_table_id = aws_route_table.myroute1.id
}

## Security group with ssh and http allow
resource "aws_security_group" "mysg" {
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "TLS for http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "TLS for ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Pavan-SG"
  }
}

#### Instance
resource "aws_instance" "myinstance1" {
        ami = "ami-08e5424edfe926b43"         # Ubuntu20.04 on AP-south-1b
        instance_type = "t2.micro"
        associate_public_ip_address = true
        key_name = "test0909" 
        subnet_id = aws_subnet.mysubnets.id
        vpc_security_group_ids = [aws_security_group.mysg.id]
        user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update
        sudo apt-get install apache2 -y
        echo "Hello From PAVAN" > /var/www/html/index.html
        sudo systemctl restart apache2
        sudo systemctl enable apache2
        EOF
        tags = {
                Name = "Webserver1"
        }
}

