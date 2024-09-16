# Configure the AWS provider
provider "aws" {
  region = "ap-south-1"
}

# Key Pair
resource "aws_key_pair" "example" {
  key_name   = "vpc-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create a VPC
resource "aws_vpc" "Tvpc" {
  cidr_block = var.aws_vpc
  tags = {
    Name = "MyVPC"
  }
}

# AWS Subnet
resource "aws_subnet" "Tsubnet" {
  vpc_id                  = aws_vpc.Tvpc.id
  cidr_block              = var.aws_subnet
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "MySubnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Tvpc.id
  tags = {
    Name = "MyInternetGateway"
  }
}

# Route Table
resource "aws_route_table" "TRT" {
  vpc_id = aws_vpc.Tvpc.id

  route {
    cidr_block = "0.0.0.0/0"  # Route for all external traffic
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}

# Route Table Association
resource "aws_route_table_association" "association-1" {
  subnet_id      = aws_subnet.Tsubnet.id
  route_table_id = aws_route_table.TRT.id
}

# Security Group
resource "aws_security_group" "vpc_s" {
  name  = "vpc-s"
  vpc_id = aws_vpc.Tvpc.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-s"
  }
}

# EC2 Instance
resource "aws_instance" "server" {
  ami                    = var.aws_instance
  instance_type          = var.aws_instance_type
  key_name               = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.vpc_s.id]
  subnet_id              = aws_subnet.Tsubnet.id

  connection {
    type        = "ssh"
    user        = "ubuntu"  # Ensure this matches your AMI
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",
      "sudo apt-get install -y python3-pip",
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py &"
    ]
  }

  tags = {
    Name = "MyServer"
  }
}
