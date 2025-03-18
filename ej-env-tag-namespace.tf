module "ej_env_tag_namespace" {
  source             = "github.com/oci-landing-zones/terraform-oci-modules-governance//tags?ref=v0.1.4"
  tenancy_ocid       = var.tenancy_ocid
  tags_configuration = local.tags_configuration
   providers = { oci = oci}
}


locals {
  env_tags_configuration = {
    default_compartment_id : local.enclosing_compartment_id
    namespaces : {
      EJ-NAMESPACE : {
        name : "ej",
        description : "EJ env tag namespace.",
        is_retired : false,
        tags : {
          ENVIRONMENT-TAG : {
            name : "env",
            description : "Environment class. high for production, low for others, like development, test, sandbox etc.",
            valid_values : ["prod", "prod-shared", "dev", "clone"], # tag values are checked against these values upon resource tagging.
          }
        }
      }
    }
  }

}
