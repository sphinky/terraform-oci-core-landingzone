# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/



module "lz_groups" {
  source               = "github.com/oci-landing-zones/terraform-oci-modules-iam//groups?ref=v0.2.7"
  count                = 1
  providers            = { oci = oci }
  tenancy_ocid         = var.tenancy_ocid
  groups_configuration = local.groups_configuration
}

module "lz_compartments" {
  count                      = 1
  source                     = "github.com/oci-landing-zones/terraform-oci-modules-iam//compartments?ref=v0.2.4"
  providers                  = { oci = oci }
  tenancy_ocid               = var.tenancy_ocid
  compartments_configuration = local.enclosed_compartments_configuration
}

module "lz_policies" {
  depends_on             = [module.lz_compartments, module.lz_groups]
  source                 = "github.com/oci-landing-zones/terraform-oci-modules-iam//policies?ref=v0.2.4"
  providers              = { oci = oci }
  tenancy_ocid           = var.tenancy_ocid
  policies_configuration = local.policies_configuration
}

locals {

  app_cmp = {
    ("APM_CMP_1222") : {
      name : "ej_app_apm_cmp",
      description : "APM App Compartment",
      defined_tags : local.cmps_defined_tags,
      freeform_tags : local.cmps_freeform_tags,
      children : {}
    }
  }

  all_enclosed_compartments = merge(local.app_cmp)

  enclosed_compartments_configuration = {
    default_parent_id : local.enclosing_compartment_id
    compartments : local.all_enclosed_compartments
  }


  prod_admin_group = {
    ("PROD_ADMIN_GROUP") = {
      name          = "ej_prod_admin_grp"
      description   = "Core Landing Zone group for storage services management."
      members       = []
      defined_tags  = local.groups_defined_tags
      freeform_tags = local.groups_freeform_tags
    }
  }

  
  prod_deploy_group = {
    ("DEV_ADMIN_GROUP") = {
      name          = "ej_prod_deploy_grp"
      description   = "Core Landing Zone group for storage services management."
      members       = []
      defined_tags  = local.groups_defined_tags
      freeform_tags = local.groups_freeform_tags
    }
  }
  
  groups_configuration = {
    groups : merge(local.prod_admin_group, local.dev_admin_group)
  }

  ## AppDev admin grants on APM compartment
  appdev_admin_grants_on_appdev_cmp = [
    "allow group ${join(",", local.appdev_admin_group_name)} to read all-resources in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage functions-family in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage api-gateway-family in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage ons-family in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage streams in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage cluster-family in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage alarms in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage metrics in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage logging-family in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage instance-family in compartment ${local.app_compartment_name}",
    # CIS 1.2 - 1.14 Level 2
    "allow group ${join(",", local.appdev_admin_group_name)} to manage volume-family in compartment ${local.app_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage object-family in compartment ${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage file-family in compartment ${local.app_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage repos in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage orm-stacks in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage orm-jobs in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage orm-config-source-providers in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read audit-events in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read work-requests in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage bastion-session in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage cloudevents-rules in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read instance-agent-plugins in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage keys in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to use key-delegate in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage secret-family in compartment ${local.app_compartment_name}"
  ]

  ## AppDev admin grants on Network compartment
  appdev_admin_grants_on_network_cmp = [
    "allow group ${join(",", local.appdev_admin_group_name)} to read virtual-network-family in compartment ${local.network_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to use subnets in compartment ${local.network_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to use network-security-groups in compartment ${local.network_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to use vnics in compartment ${local.network_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage private-ips in compartment ${local.network_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to use load-balancers in compartment ${local.network_compartment_name}"
  ]

  ## AppDev admin grants on Security compartment
  appdev_admin_grants_on_security_cmp = [
    "allow group ${join(",", local.appdev_admin_group_name)} to use vaults in compartment ${local.security_compartment_name}",
    #"allow group ${join(",",local.appdev_admin_group_name)} to inspect keys in compartment ${local.security_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage instance-images in compartment ${local.security_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read vss-family in compartment ${local.security_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to use bastion in compartment ${local.security_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to manage bastion-session in compartment ${local.security_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read logging-family in compartment ${local.security_compartment_name}"
  ]

  ## AppDev admin grants on Database compartment
  appdev_admin_grants_on_database_cmp = [
    "allow group ${join(",", local.appdev_admin_group_name)} to read autonomous-database-family in compartment ${local.app_compartment_name}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read database-family in compartment ${local.database_compartment_name}"
  ]

  ## AppDev admin grants on enclosing compartment
  appdev_admin_grants_on_enclosing_cmp = [
    "allow group ${join(",", local.appdev_admin_group_name)} to read app-catalog-listing in ${local.policy_scope}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read instance-images in ${local.policy_scope}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read repos in ${local.policy_scope}"
  ]

  ## All AppDev admin grants
  appdev_admin_grants = concat(local.appdev_admin_grants_on_appdev_cmp, local.appdev_admin_grants_on_network_cmp,
  local.appdev_admin_grants_on_security_cmp, local.appdev_admin_grants_on_database_cmp, local.appdev_admin_grants_on_enclosing_cmp)


  ## AppDev deploy grants on enclosing compartment
  appdev_deploy_grants_on_enclosing_cmp = [
    "allow group ${join(",", local.appdev_admin_group_name)} to read app-catalog-listing in ${local.policy_scope}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read instance-images in ${local.policy_scope}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read repos in ${local.policy_scope}"
  ]

  ## AppDev deploy grants on enclosing compartment
  appdev_deploy_grants_on_appdev_cmp = [
    "allow group ${join(",", local.appdev_admin_group_name)} to read app-catalog-listing in ${local.policy_scope}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read instance-images in ${local.policy_scope}",
    "allow group ${join(",", local.appdev_admin_group_name)} to read repos in ${local.policy_scope}"
  ]
  ## All AppDev deploy grants
  appdev_deploy_grants = concat(local.appdev_deploy_grants_on_appdev_cmp, local.appdev_deploy_grants_on_enclosing_cmp)


  default_policies = {
    ("ej-admin-policy") = {
      compartment_id = local.non_prod_compartment_id
      name           = ej-app-admin-apm-policy
      description    = "Core Landing Zone policy for ${join(",", local.exainfra_admin_group_name)} group to manage Exadata infrastructures in compartment ${local.exainfra_compartment_name}."
      defined_tags   = local.policies_defined_tags
      freeform_tags  = local.policies_freeform_tags
      statements     = local.appdev_admin_grants
    },
    ("ej-deploy-policy") = {
      compartment_id = local.non_prod_compartment_id
      name           = ej-app-admin-apm-policy
      description    = "Core Landing Zone policy for ${join(",", local.exainfra_admin_group_name)} group to manage Exadata infrastructures in compartment ${local.exainfra_compartment_name}."
      defined_tags   = local.policies_defined_tags
      freeform_tags  = local.policies_freeform_tags
      statements     = local.appdev_deploy_grants
    }
  }


}

