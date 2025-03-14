module "apm-non-prod-app-123" {
  source                   = "./application-module"
  enclosing_compartment_id = local.enclosing_compartment_id
  enclosing_compartment_name = "ej-top-cmp"
  app_name                 = "apm-123"
  default_domain_url       = local.default_domain_url
  env ="non-prod"
  svc_user_public_key = ""
  tenancy_ocid = local.tenancy_ocid
}
