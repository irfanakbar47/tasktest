resource "aws_eks_cluster" "task_cluster" {
  name     = "task-eks-cluster"
  role_arn = aws_iam_role.task_eks_role.arn

  vpc_config {
    subnet_ids       = aws_subnet.task_public_subnet[*].id  # Private subnets for worker nodes
    security_group_ids = [aws_security_group.task_eks_cluster_sg.id]  # Attach cluster SG
  }

  depends_on = [aws_iam_role_policy_attachment.task_eks_policy]
}


resource "aws_launch_template" "task_worker_template" {
  name_prefix   = "task-worker-"
  #image_id      = "ami-0c55b159cbfafe1f0"  # Replace with your preferred AMI
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true  # Set this to false if you don't want public IPs
    security_groups             = [aws_security_group.task_worker_sg.id]  # Attach worker node SG
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "task_node_group_instances" {
  cluster_name    = aws_eks_cluster.task_cluster.name
  node_group_name = "task-node-group"
  node_role_arn   = aws_iam_role.task_eks_node_group_role.arn
  subnet_ids      = aws_subnet.task_public_subnet[*].id  # Use public subnets for worker nodes

  launch_template {
    id      = aws_launch_template.task_worker_template.id
    version = "$Latest"  # Use the latest version of the launch template
  }

  scaling_config {
    desired_size = 4
    max_size     = 6
    min_size     = 4
  }

  depends_on = [aws_iam_role_policy_attachment.task_node_policy]
}


