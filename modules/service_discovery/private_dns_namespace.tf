resource "aws_service_discovery_private_dns_namespace" "default" {
  name        = "teamcity.local"
  description = ""
  vpc         = local.vpc_id
}
