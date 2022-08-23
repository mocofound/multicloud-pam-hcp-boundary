resource "hcp_hvn" "boundary_hvn" {
  hvn_id = "${var.prefix}-hvn"
  region = "us-east-1"
  cloud_provider = "aws"
}