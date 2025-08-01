### The Righteous SG ###
resource "aws_security_group" "jenkins_sg" {
  vpc_id = var.vpc_id
  tags = {
    Name = "Jenkins_SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allowed_jenkins_ingress_ports" {
  for_each          = var.allowed_ports
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
  tags = {
    "name" = "${each.key}_port_ingress"
  }
}

resource "aws_vpc_security_group_egress_rule" "allowed_jenkins_eg_ports" {
  for_each          = var.allowed_ports
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
  tags = {
    "name" = "${each.key}_port_egress"
  }
}

resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "Jenkins_instance"
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn
  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 6
    max_size     = 7
    min_size     = 3
  }

  instance_types = [var.node_instance_type]
}
