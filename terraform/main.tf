provider "aws" {
    region = var.region
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
        cidr_blocks = ["${var.my_ip}/32"]
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
    instance_type = var.instance_type

    vpc_security_group_ids = [aws_security_group.web_sg.id]

    key_name = "cloud-key-new"

    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install docker -y
                service docker start
                usermod -aG docker ec2-user
                docker pull ${var.docker_image}
                docker run -d -p 80:5000 ${var.docker_image}
                EOF

    tags = {
        Name = "terraform-cloud-app"
    }
}