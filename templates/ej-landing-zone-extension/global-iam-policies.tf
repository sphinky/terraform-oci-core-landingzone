## TODO add db admin and ops groups (one set for production; another for non-prod) + policies
# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/


module "lz_policies" {
  source                 = "github.com/oci-landing-zones/terraform-oci-modules-iam//policies?ref=v0.2.4"
  providers              = { oci = oci }
  tenancy_ocid           = local.tenancy_ocid
  policies_configuration = local.policies_configuration
}

locals {

  groups_defined_tags    = null
  groups_freeform_tags   = null
  policies_defined_tags  = null
  policies_freeform_tags = null

  # groups
  # THIS is where we map to existing groups coming from ENTRA
  db_admins_group_prod_name     = "ej-db-admins-prod"
  db_admins_group_non_prod_name = "ej-db-admins-non-prod"

  # hardcode the prod and non-prod contianer (and security and network) compartment names
  prod_compartment_name     = "ej-prod-cmp"
  non_prod_compartment_name = "ej-non-prod-cmp"
  security_compartment_name = "ej-security-cmp"
  network_compartment_name  = "ej-network-cmp"


  ###########################################################################
  ## (ONE) deploy group grants on APP compartment
  ###########################################################################

  db_admins_grants_on_prod_cmp = [
    "allow group ${local.db_admins_group_prod_name} to manage autonomous-databases in compartment ${local.prod_compartment_name}",
    "allow group ${local.db_admins_group_prod_name} to manage autonomous-backups in compartment ${local.prod_compartment_name}",
    "allow group ${local.db_admins_group_prod_name} to manage database-connections in compartment ${local.prod_compartment_name}",
    "allow group ${local.db_admins_group_prod_name} to use keys in compartment ${local.security_compartment_name}",
    "allow group ${local.db_admins_group_prod_name} to use vaults in compartment ${local.security_compartment_name}",
    "allow group ${local.db_admins_group_prod_name} to use virtual-network-family in compartment ${local.network_compartment_name}",
    "allow group ${local.db_admins_group_prod_name}  to use subnets in compartment ${local.network_compartment_name}",
    "allow group ${local.db_admins_group_prod_name}  to use network-security-groups in compartment ${local.network_compartment_name}",
    "allow group ${local.db_admins_group_prod_name}  to use vnics in compartment ${local.network_compartment_name}"


  ]

  db_admins_grants_on_non_prod_cmp = [
    "allow group ${local.db_admins_group_non_prod_name} to manage autonomous-databases in compartment ${local.prod_compartment_name}",
    "allow group ${local.db_admins_group_non_prod_name} to manage autonomous-backups in compartment ${local.prod_compartment_name}",
    "allow group ${local.db_admins_group_non_prod_name} to manage database-connections in compartment ${local.prod_compartment_name}",
    "allow group ${local.db_admins_group_non_prod_name} to use keys in compartment ${local.security_compartment_name}",
    "allow group ${local.db_admins_group_non_prod_name} to use vaults in compartment ${local.security_compartment_name}",
    "allow group ${local.db_admins_group_non_prod_name} to use virtual-network-family in compartment ${local.network_compartment_name}",
    "allow group ${local.db_admins_group_non_prod_name} to use subnets in compartment ${local.network_compartment_name}",
    "allow group ${local.db_admins_group_non_prod_name} to use network-security-groups in compartment ${local.network_compartment_name}",
    "allow group ${local.db_admins_group_non_prod_name} to use vnics in compartment ${local.network_compartment_name}"
  ]

  ## All deploy grants
  db_admin_grants = concat(local.db_admins_grants_on_non_prod_cmp, local.db_admins_grants_on_prod_cmp)



  ###################################################################################
  ## (TWO) setup policy configuration
  ###################################################################################

  db_policies_in_enclosing_cmp = {
    ("ej-db-admins-policy") = {
      compartment_id = local.enclosing_compartment_id
      name           = "policy-db-admins"
      description    = "LZ policy for prod and non-prod db admins groups to manage db's in prod and non-prod compartments"
      defined_tags   = local.policies_defined_tags
      freeform_tags  = local.policies_freeform_tags
      statements     = local.db_admin_grants
    }
  }

  policies_configuration = {
    enable_cis_benchmark_checks : false
    supplied_policies : local.db_policies_in_enclosing_cmp
  }
}

