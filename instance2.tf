resource "aws_instance" "myinstance2" {
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
        echo "Hello From PAVAN from server2" > /var/www/html/index.html
        sudo systemctl restart apache2
        sudo systemctl enable apache2
        EOF
        tags = {
                Name = "Webserver2"
        }
}

