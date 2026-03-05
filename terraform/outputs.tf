output "public_ip" {
    description = "Public IP of EC2 instance"
    value = aws_instance.cloud_app.public_ip
}