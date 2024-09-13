output "instance_id" {
  value = aws_instance.example.id
}
output "ip_address" {
  value = aws_instance.example.public_ip
}
output "private_ip" {
  value = aws_instance.example.private_ip
}
output "instance_state" {
  value = aws_instance.example.instance_state
}
output "security_groups" {
  value = aws_instance.example.security_groups
}