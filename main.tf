provider "aws" {
  region = "ap-south-1"  # Set your desired AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-0e53db6fd757e38c7"  # Specify an appropriate AMI ID
  instance_type = "t2.micro"
  subnet_id     = "subnet-0809dd414ab855aa6"  # Ensure the subnet ID is in quotes
  key_name      = "krupakar_new"

  tags = {
    Name = "example-instance"  # Add a tag for easier identification
  }
}
