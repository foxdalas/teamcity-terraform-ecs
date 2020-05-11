output "name" {
  value = aws_ecs_cluster.default.name
}

output "id" {
  value = aws_ecs_cluster.default.id
}

output "arn" {
  value = aws_ecs_cluster.default.arn
}

output "iam_instance_profile_arn" {
  value = aws_iam_instance_profile.ecs_node.arn
}

output "ecs_service_role_name" {
  value = aws_iam_role.ecs_service_role.name
}

output "ecs_default_task_role_name" {
  value = aws_iam_role.ecs_task_role.name
}

output "ecs_default_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "ecs_capacity_provider_name" {
  value = aws_ecs_capacity_provider.asg.name
}