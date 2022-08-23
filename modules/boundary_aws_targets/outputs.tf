output "rds_db_address" {
  value = aws_db_instance.rds.address
}
output "rds_db_name" {
  value = aws_db_instance.rds.db_name
}

output "ssh_private_key_pem" {
  value = tls_private_key.boundary_poc.private_key_pem
}

output "aws_rds_db" {
  value = aws_db_instance.rds
}

output "aws_ec2_instance" {
  value = aws_instance.boundary_poc
}