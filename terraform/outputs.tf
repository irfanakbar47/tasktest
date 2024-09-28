# outputs of subnets

output "public_subnets" {
  value = aws_subnet.task_public_subnet[*].id
}

# Output the DNS name of the Classic Load Balancer
#output "clb_dns_name" {
 # description = "The DNS name of the Classic Load Balancer"
#  value       = aws_elb.task_clb.dns_name
#}

# outputs of DNS-lb
#output "alb_dns_name" {
#  description = "The DNS name of the ALB to be accessed from the internet"
#  value       = aws_lb.task_alb.dns_name
#}