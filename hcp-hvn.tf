resource "hcp_hvn" "my_hvn" {
  hvn_id = "boundary-hvn"
  region = "us-east-1"
  cloud_provider = "aws"
}