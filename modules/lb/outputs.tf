# --------------
# Module Outputs
# --------------
output "name" {
  value = aws_lb.main.name
}

output "target_group" {
  value = aws_lb_target_group.main
}

output "dns_name" {
  value = aws_lb.main.dns_name
}