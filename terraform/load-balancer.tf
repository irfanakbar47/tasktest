data "aws_instances" "target_group_instances" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.task_vpc.id]
  }
}


# Create Classic Load Balancer
resource "aws_elb" "task_clb" {
  name               = "task-clb"
#  availability_zones = data.aws_availability_zones.available.names
  security_groups    = [aws_security_group.task_lb_sg.id]
  subnets            = aws_subnet.task_public_subnet[*].id

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  instances = data.aws_instances.target_group_instances.ids

  tags = {
    Name = "task-clb"
  }
}



/** resource "aws_lb" "task_alb" {
  name               = "task-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.task_lb_sg.id]
  subnets            = aws_subnet.task_public_subnet[*].id
}

resource "aws_lb_target_group" "task_tg" {
  name     = "task-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.task_vpc.id
  target_type = "instance"

  health_check {
    path     = "/"
    protocol = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "task_http_listener" {
  load_balancer_arn = aws_lb.task_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.task_tg.arn
  }
}
**/
