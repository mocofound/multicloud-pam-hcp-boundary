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

output "aws_ec2_windows_instance" {
  value = aws_instance.windows-server
}

output "azure_tls_private_key" {
  value     = tls_private_key.boundary_poc.private_key_pem
  sensitive = true
}

output  "aws_vpc_id" {
  value =  aws_vpc.boundary_poc.id
}

output  "aws_subnet_id" {
  value =  aws_subnet.boundary_poc.id
}