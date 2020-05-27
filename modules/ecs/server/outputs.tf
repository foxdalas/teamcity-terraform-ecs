output "aws_access_key_id" {
  value = aws_iam_access_key.server.id
}

output "aws_secret_access_key" {
  value = aws_iam_access_key.server.secret
}

output "master_server_address" {
  value = aws_lb.server.dns_name
}
