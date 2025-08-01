# output "asg_name" {
#   value = aws_autoscaling_group.jenkins_asg.name
# }

output "security_group_id" {
  value = aws_security_group.jenkins_sg.id
}

# output "public_ips" {
#   value = aws_instance.your_instance[*].public_ip
# }
