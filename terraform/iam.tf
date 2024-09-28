# EKS IAM Role
resource "aws_iam_role" "task_eks_role" {
  name = "task-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "task_eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.task_eks_role.name
}

# Node Group IAM Role
resource "aws_iam_role" "task_eks_node_group_role" {
  name = "task-eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "task_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.task_eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "task_node_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.task_eks_node_group_role.name
}

# Add the AmazonEC2ContainerRegistryReadOnly policy to allow pulling images from ECR
resource "aws_iam_role_policy_attachment" "task_ecs_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.task_eks_node_group_role.name
}

# IAM Policy for AWS Load Balancer Controller
resource "aws_iam_policy" "task_alb_controller_policy" {
  name        = "TaskLoadBalancerControllerIAMPolicy"
  description = "Policy for alb/NLB controller in task EKS"
  policy      = file("alb_policy.json")
}

resource "aws_iam_role" "task_alb_controller_role" {
  name = "task-eks-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "task_alb_controller_policy_attachment" {
  policy_arn = aws_iam_policy.task_alb_controller_policy.arn
  role       = aws_iam_role.task_alb_controller_role.name
}

