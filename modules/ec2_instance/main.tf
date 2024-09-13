provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "terraform-1" {
  ami = var.ami_id
  instance_type = var.instance_type
}
