provider "aws" {
  region = "ap-south-1"  # Set your desired AWS region
}

resource "aws_instance" "example" {
  ami           = var.ami_id # Specify an appropriate AMI ID
  instance_type = var.shirhsa_instacnce_type
  subnet_id     = "subnet-0809dd414ab855aa6"  # Ensure the subnet ID is in quotes
  key_name      = "krupakar_new"
  security_groups = var.security_groups

  tags = {
    Name = "example-instance"  # Add a tag for easier identification
  }
}
