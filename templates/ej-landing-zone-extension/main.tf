module "apm-non-prod-app-123" {
  source                   = "./non-prod"
  enclosing_compartment_id = local.enclosing_compartment_id
  enclosing_compartment_name = "ej-top-cmp"
  app_name                 = "apm-123"
}
