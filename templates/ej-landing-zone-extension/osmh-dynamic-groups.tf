

### BEGIN: ADDED FOR OSMH ###
#get the existing app compartments in the prod/non-prod container compartments using this data source.....
data "oci_identity_compartments" "prod_app_compartments" {
  #Required (Container Compartment)
  compartment_id = local.prod_compartment_id
  #Optional
  access_level = "ANY"
}

data "oci_identity_compartments" "non_prod_app_compartments" {
  #Required (Container Compartment)
  compartment_id = local.non_prod_compartment_id
  #Optional
  access_level = "ANY"
}

module "lz_dynamic_groups_osmh" {
  depends_on                   = [data.oci_identity_compartments.prod_app_compartments, data.oci_identity_compartments.non_prod_app_compartments]
  source                       = "github.com/oci-landing-zones/terraform-oci-modules-iam//dynamic-groups?ref=v0.2.4"
  count                        = 1
  providers                    = { oci = oci }
  tenancy_ocid                 = local.tenancy_ocid
  dynamic_groups_configuration = local.osmh_dynamic_group_configuration
}
### END: ADDED FOR OSMH ###

locals {

  prod_compartment_id_values                 = [for comp in tolist(data.oci_identity_compartments.prod_app_compartments.compartments) : "resource.compartment.id = '${comp.id}'"]
  prod_compartment_id_values_comma_delimited = join(",", local.prod_compartment_id_values)
  prod_matching_rule_text                    = "ANY {${local.prod_compartment_id_values_comma_delimited}}"

  prod_osmh_dynamic_group = {
    ("OSMH_DYNAMIC_GROUP_PROD") = {
      name          = "dynamic-grp-osmh-prod"
      description   = "Core Landing Zone dynamic group for applicaiton instances. (Prod)"
      matching_rule = "${local.prod_matching_rule_text}"
      defined_tags  = null
      freeform_tags = null
    }
  }


  non_prod_compartment_id_values                 = [for comp in tolist(data.oci_identity_compartments.non_prod_app_compartments.compartments) : "resource.compartment.id = '${comp.id}'"]
  non_prod_compartment_id_values_comma_delimited = join(",", local.non_prod_compartment_id_values)
  non_prod_matching_rule_text                    = "ANY {${local.non_prod_compartment_id_values_comma_delimited}}"

  non_prod_osmh_dynamic_group = {
    ("OSMH_DYNAMIC_GROUP_NON_PROD") = {
      name          = "dynamic-grp-osmh-non-prod"
      description   = "Core Landing Zone dynamic group for applicaiton instances. (Non-Prod)"
      matching_rule = "${local.non_prod_matching_rule_text}"
      defined_tags  = null
      freeform_tags = null
    }
  }

  osmh_dynamic_group_configuration = {
    dynamic_groups : merge(local.prod_osmh_dynamic_group, local.non_prod_osmh_dynamic_group)
  }
  ### END: ADDED FOR OSMH ###
}
