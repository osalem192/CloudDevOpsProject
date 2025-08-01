variable "vpc_id" {}
variable "subnet_ids" { type = list(string) }
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "allowed_ports" {
  description = "Allowed ports for Jenkins SG"
  type        = map(string)
}

variable "cluster_name" {}
variable "eks_cluster_role_arn" {}
variable "eks_node_role_arn" {}
variable "node_instance_type" {}
