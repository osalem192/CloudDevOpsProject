variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"] # Or adapt for arm64 if needed
  }

  filter {
    name   = "architecture"
    values = ["x86_64"] # Or "arm64"
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 SSH access"
  type        = string
  default     = "my-key"
}

variable "allowed_ports" {
  description = "Allowed ports for Jenkins SG"
  type        = map(string)
  default = {
    "SSH"            = 22
    "Jenkins_Agent"  = 5000
    "Jenkins_Master" = 8080
    "HTTP"           = 80
    "HTTPS"          = 443
  }
}

variable "cluster_name" {
  default = "iVolve_Cluster"
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "eks_cluster_role_arn" {
  description = "IAM role ARN for EKS Cluster"
  default     = "arn:aws:iam::234561105436:role/c164490a4237002l11069382t1w234561-LabEksClusterRole-L9YqpeGTCdee"

}

variable "eks_node_role_arn" {
  description = "IAM role ARN for Node Group"
  default     = "arn:aws:iam::234561105436:role/c164490a4237002l11069382t1w234561105-LabEksNodeRole-EsVruoGEK26Z"
}
