output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

# output "asg_name" {
#   value = module.server.asg_name
# }

output "security_group_id" {
  value = module.server.security_group_id
}
