
# Cluster Security Group
resource "aws_security_group" "task_eks_cluster_sg" {
  name   = "task-eks-cluster-sg"
  vpc_id = aws_vpc.task_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.task_worker_sg.id]  # Allow communication from worker nodes
    description = "Allow worker nodes to communicate with the EKS cluster API"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task-eks-cluster-sg"
  }
}
# Worker Node Security Group
resource "aws_security_group" "task_worker_sg" {
  name   = "task-worker-sg"
  vpc_id = aws_vpc.task_vpc.id

  # Allow HTTP traffic from the Load Balancer
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.task_lb_sg.id]  # Allow from the Load Balancer SG
    description = "Allow HTTP traffic from Load Balancer"
  }

  # Allow HTTPS traffic from the Load Balancer
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.task_lb_sg.id]  # Allow from the Load Balancer SG
    description = "Allow HTTPS traffic from Load Balancer"
  }

  # Allow health checks from the Load Balancer (must be unique)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow health checks from anywhere
    description = "Allow health checks from Load Balancer"
  }

  # Allow internal communication within the VPC (e.g., for service discovery)
  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Adjust this to your VPC CIDR range
    description = "Allow internal traffic from within the VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task-worker-sg"
  }
}


# Load Balancer Security Group
resource "aws_security_group" "task_lb_sg" {
  name        = "task-lb-sg"
  description = "Security Group for the Classic Load Balancer"
  vpc_id      = aws_vpc.task_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to public
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task-lb-sg"
  }
}