provider "aws" {
    region = "eu-west-1"
}

resource "aws_security_group" "web_sg" {
    name = "terraform-web-sg"
    description = "Allow HTTP and SSH access"

    ingress {
        description = "Allow HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow SSH from my IP"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["80.111.21.32/32"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "terraform-web-sg"
    }
}

resource "aws_instance" "cloud_app" {
    ami = "ami-09c20105c9b62f893"
    instance_type = "t3.micro"

    vpc_security_group_ids = [aws_security_group.web_sg.id]

    key_name = "cloud-key-new"

    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install docker -y
                service docker start
                usermod -aG docker ec2-user
                docker pull siddheeshhh/cloud-app:v2
                docker run -d -p 80:5000 siddheeshhh/cloud-app:v2
                EOF

    tags = {
        Name = "terraform-cloud-app"
    }
}

output "public_ip" {
    value = aws_instance.cloud_app.public_ip
}