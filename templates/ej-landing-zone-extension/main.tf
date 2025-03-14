module "apm-non-prod-app-123" {
  source                     = "./application-module"
  enclosing_compartment_id   = local.enclosing_compartment_id
  enclosing_compartment_name = "ej-top-cmp"
  prod_compartment_id = "ocid1.compartment.oc1..aaaaaaaalfkyplfgm33bkbychsiijyd6ecey6j6qlkbodur76tcqezpeddza"
  non_prod_compartment_id = "ocid1.compartment.oc1..aaaaaaaafdkh3x5cpgglzaijisgocban4nuvburoylbbkjapj5vz4umr35sq"
  app_name                   = "1234534pr01"
  default_domain_url         = local.default_domain_url
  env                        = "prod"
  svc_user_public_key        = <<EOT
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv5enhxZyAQnwL974UShm
OUL5J/2wzF4sU6Yyl6d5gk2+WswYEtTeA1uwy5Q7i7JJkBbV9mM9nbYhhFm9Ot+w
OxdVdJ2NIU+leWbeMZs28vGeuJrglA/Jk0rX4wJml01qbkfEPRCWB7KF78+MUjFn
UJumP0DyakSoXgETeN66GvksuhQiU7qVEZ/bPGaLiecv6+D2VPG7/gcQLkR+jVxg
DFM3Xi89RIjV7fLwnYSDAgw9NKb9yb6CGmZM4U0kkaIlmyRipPrAiaNyAk0yr2Yv
NJ38RpPhN5YpSPxAMlHTAIwvboz2ZszYF4tR46PCfaEv+EYW5U9Ahws9eDpX4iek
RQIDAQAB
-----END PUBLIC KEY-----
EOT
  tenancy_ocid               = local.tenancy_ocid
  providers = {
    oci = oci
  }
  devops_group_name = "sphinx-devops"
}
