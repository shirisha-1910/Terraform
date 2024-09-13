output "public-ip-address" {
  value = aws_instance.terraform-1.public_ip
}