output "bastion_ssh_cmd" {
  value = "ssh -A ec2-user@${module.bastion.public_ip}"
}

output "teamcity_url" {
  value = "http://${module.alb.dns_name}"
}

output "aws_access_key_id" {
  value = module.server.aws_access_key_id
}

output "aws_secret_access_key" {
  value = module.server.aws_secret_access_key
}

output "ecs_cluster_name" {
  value = module.ecs.name
}

output "ecs_taskdefinition_name" {
  value = module.agent.task_definition_name
}
