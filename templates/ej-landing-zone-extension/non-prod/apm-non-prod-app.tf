# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/


## this is the app name.. it will be part of the created compartment name.
## the generated container compartment will have the name ej-app-${app_name}-cmp
## don't use underscores in the name.. better use dashes.
variable "app_name" {
  type = string
}

## the enclosing compartment is the compartment that 'encloses' the landding zone.. in our case the ej-top-cmp.
variable "enclosing_compartment_id" {
  type = string
}

variable "enclosing_compartment_name" {
  type = string
}

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
  cmps_defined_tags      = null
  cmps_freeform_tags     = null
  groups_defined_tags    = null
  groups_freeform_tags   = null
  policies_defined_tags  = null
  policies_freeform_tags = null

  # compartment
  app_compartment_name = "ej-app-${app_name}-cmp"
  app_cmp = {
    ("APP_CMP") : {
      name : "${app_compartment_name}",
      description : "Application ${app_name} Compartment",
      defined_tags : local.cmps_defined_tags,
      freeform_tags : local.cmps_freeform_tags,
      children : {}
    }
  }
  network_compartment_name  = "ej-network-cmp"
  security_compartment_name = "ej-security-cmp"

  all_enclosed_compartments = merge(local.app_cmp)

  enclosed_compartments_configuration = {
    default_parent_id : var.enclosing_compartment_id
    compartments : local.all_enclosed_compartments
  }

  # groups
  # mapped to entraid
  # TODO add mapping code
  devops_group_name = "ej-devops-${app_name}-grp"
  devops_group = {
    ("DEVOPS_GROUP") = {
      name          = "${devops_group_name}"
      description   = "Core Landing Zone group for storage services management."
      members       = []
      defined_tags  = local.groups_defined_tags
      freeform_tags = local.groups_freeform_tags
    }
  }

  # local group
  # contains one local user with an api key.
  # that user will not have console ui capability.. no access to console
  # supply public key as input
  # TODO add code to create user
  deploy_group_name = "ej-deploy-${app_name}-grp"
  deploy_group = {
    ("DEPLOY_GROUP") = {
      name          = "${deploy_group_name}"
      description   = "Core Landing Zone group for storage services management."
      members       = []
      defined_tags  = local.groups_defined_tags
      freeform_tags = local.groups_freeform_tags
    }
  }

  groups_configuration = {
    groups : merge(local.devops_group, local.deploy_group)
  }

  ###################################
  ## deploy grants on APP compartment
  ###################################
  deploy_grants_on_app_cmp = [
    "allow group ${join(",", local.devops_group_name)} to read all-resources in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage functions-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage api-gateway-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage ons-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage streams in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage cluster-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage alarms in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage metrics in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage logging-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage instance-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    # CIS 1.2 - 1.14 Level 2
    "allow group ${join(",", local.devops_group_name)} to manage volume-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
    "allow group ${join(",", local.devops_group_name)} to manage object-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
    "allow group ${join(",", local.devops_group_name)} to manage file-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
    "allow group ${join(",", local.devops_group_name)} to manage repos in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage orm-stacks in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage orm-jobs in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage orm-config-source-providers in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to read audit-events in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to read work-requests in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage bastion-session in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage cloudevents-rules in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to read instance-agent-plugins in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage keys in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to use key-delegate in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage secret-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to read autonomous-database-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to read database-family in compartment ej-app-non-prod-cmp:${local.app_compartment_name}"
  ]
  ## deploy grants on Network compartment
  deploy_grants_on_network_cmp = [
    "allow group ${join(",", local.devops_group_name)} to read virtual-network-family in compartment ${local.network_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to use subnets in compartment ${local.network_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to use network-security-groups in compartment ${local.network_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to use vnics in compartment ${local.network_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage private-ips in compartment ${local.network_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to use load-balancers in compartment ${local.network_compartment_name}"
  ]
  ## deploy grants on Security compartment
  deploy_grants_on_security_cmp = [
    "allow group ${join(",", local.devops_group_name)} to use vaults in compartment ${local.security_compartment_name}",
    #"allow group ${join(",",local.devops_group_name)} to inspect keys in compartment ${local.security_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage instance-images in compartment ${local.security_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to read vss-family in compartment ${local.security_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to use bastion in compartment ${local.security_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to manage bastion-session in compartment ${local.security_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to read logging-family in compartment ${local.security_compartment_name}"
  ]

  ## deploy grants in tenancy
  deploy_grants_on_tenancy = [
    "allow group ${join(",", local.devops_group_name)} to read app-catalog-listing in ${var.enclosing_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to read instance-images in ${var.enclosing_compartment_name}",
    "allow group ${join(",", local.devops_group_name)} to read repos in ${var.enclosing_compartment_name}"
  ]

  ## All deploy grants
  deploy_grants = concat(local.deploy_grants_on_app_cmp, local.deploy_grants_on_security_cmp, local.deploy_grants_on_security_cmp, local.deploy_grants_on_tenancy)

  ###################################
  ## devops grants on app compartment
  ###################################
  devops_grants_on_app_cmp = [
    "allow group ${join(",", local.devops_group_name)} to use all-resources in ej-app-non-prod-cmp:${local.app_compartment_name}",
  ]

  ## All devops grants
  devops_grants = concat(local.deploy_grants_on_app_cmp)

# TODO one policy per application?
  app_policies_in_enclosing_cmp = {
    ("ej-devops-policy") = {
      compartment_id = var.enclosing_compartment_id
      name           = "ej-devops-${var.app_name}-policy"
      description    = "LZ policy for ${join(",", local.devops_group_name)} group to manage infrastructure in compartment ej-app-non-prod-cmp:${local.app_compartment_name}."
      defined_tags   = local.policies_defined_tags
      freeform_tags  = local.policies_freeform_tags
      statements     = local.devops_grants
    },
    ("ej-deploy-policy") = {
      compartment_id = var.enclosing_compartment_id
      name           = "ej-depoy-${var.app_name}-policy"
      description    = "LZ policy for ${join(",", local.deploy_group_name)} group to manage infrastructure in compartment ej-app-non-prod-cmp:${local.app_compartment_name}."
      defined_tags   = local.policies_defined_tags
      freeform_tags  = local.policies_freeform_tags
      statements     = local.deploy_grants
    }
  }

  policies_configuration = {
    enable_cis_benchmark_checks : false
    supplied_policies : local.app_policies_in_enclosing_cmp
  }
}

