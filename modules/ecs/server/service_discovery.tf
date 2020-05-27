resource "aws_service_discovery_service" "server" {
  name = "_${local.name}"

  dns_config {
    namespace_id = local.sd_namespace_id

    dns_records {
      ttl  = 10
      type = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
