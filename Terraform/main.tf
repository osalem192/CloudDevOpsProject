provider "aws" {
  region = "us-east-1"
}

module "network" {
  source         = "./modules/network"
  vpc_cidr       = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  azs            = ["us-east-1a", "us-east-1b"]
}

module "server" {
  source               = "./modules/server"
  vpc_id               = module.network.vpc_id
  subnet_ids           = module.network.public_subnet_ids
  ami_id               = data.aws_ami.amazon_linux_2023.id # Amazon Linux 2023
  allowed_ports        = var.allowed_ports
  instance_type        = "t2.micro"
  cluster_name         = var.cluster_name
  eks_cluster_role_arn = var.eks_cluster_role_arn
  eks_node_role_arn    = var.eks_node_role_arn
  node_instance_type   = var.instance_type
  key_name             = "my-key"
}
