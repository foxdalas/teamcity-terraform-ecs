resource "aws_db_instance" "default" {
  identifier             = local.name
  allocated_storage      = local.allocated_storage
  storage_type           = local.storage_type
  engine                 = local.engine
  engine_version         = local.engine_version
  instance_class         = local.instance_class
  name                   = local.database
  username               = local.username
  password               = local.password
  parameter_group_name   = local.parameter_group_name
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.default.id]
  skip_final_snapshot    = true
}
