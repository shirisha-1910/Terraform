variable "aws_vpc" {
    default = "10.0.0.0/16"
}
variable "aws_subnet" {
  default = "10.0.1.0/24"
}
variable "aws_instance" {
  default = "ami-0522ab6e1ddcc7055"
}
variable "aws_instance_type" {
  default = "t2.micro"
}