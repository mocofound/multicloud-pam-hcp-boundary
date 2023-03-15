#  resource "boundary_auth_method_oidc" "okta" {
#   name                 = "Okta"
#   description          = "OIDC auth method for Okta"
#   scope_id             = "o_1234567890"                  # updateme
#   issuer             = "https://dev-1944432.okta.com"    # updateme
#   client_id          = "0oal6ftPGZ0DSbr5d6"            # updateme
#   client_secret      = "4BSQlbuTTrh5P-JhGAKW2FVPh48idEbCAOWWVXM"   # updateme
#   signing_algorithms = ["RS256"]
#   api_url_prefix     = "https://BOUNDARY_ADDR"                 # updateme
#   state = "active"
# }

# resource "boundary_managed_group" "idp_okta_aws_users" {
#   name           = "idp_okta_aws_users"
#   description    = "GAWS users as defined by external IDP/auth method"
#   auth_method_id = boundary_auth_method_oidc.auth.id
#   #Below uses AAD groupid, which could be a module output from AAD/oidc module
#   filter         = "\"89fa53c6-bdcb-4dd1-8ada-0387296f9918\" in \"/token/groups\""
# }

