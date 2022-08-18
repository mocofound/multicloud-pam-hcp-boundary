output "public_url" {
  value = "http://${aws_eip.hashicat.public_dns}"
}

output "public_ip" {
  value = "http://${aws_eip.hashicat.public_ip}"
}