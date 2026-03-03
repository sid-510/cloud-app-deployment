provider "aws" {
    region = "eu-west-1"
}

resource "aws_instance" "cloud_app" {
    ami = "ami-09c20105c9b62f893"
    instance_type = "t3.micro"

    tags = {
        Name = "terraform-cloud-app"
    }
}