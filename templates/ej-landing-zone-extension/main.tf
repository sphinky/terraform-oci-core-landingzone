module "apm-non-prod-app-123" {
  source                     = "./application-module"
  enclosing_compartment_id   = local.enclosing_compartment_id
  enclosing_compartment_name = "ej-top-cmp"
  app_name                   = "1234534pr01"
  default_domain_url         = local.default_domain_url
  env                        = "prod"
  svc_user_public_key        = ""
  tenancy_ocid               = local.tenancy_ocid
  providers = {
    oci = oci
  }
}
