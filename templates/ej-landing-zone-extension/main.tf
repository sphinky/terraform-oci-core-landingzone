module "apm-non-prod-app-123" {
  source                   = "./non-prod"
  enclosing_compartment_id = local.enclosing_compartment_id
  app_name                 = "apm-non-prod-app-123"
}
