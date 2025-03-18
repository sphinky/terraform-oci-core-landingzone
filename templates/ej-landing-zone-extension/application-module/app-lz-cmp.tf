# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/


/*
module "lz_groups" {
  source               = "github.com/oci-landing-zones/terraform-oci-modules-iam//groups?ref=v0.2.7"
  count                = 1
  providers            = { oci = oci }
  tenancy_ocid         = var.tenancy_ocid
  groups_configuration = local.groups_configuration
}*/

module "lz_compartments" {
  count                      = 1
  source                     = "github.com/oci-landing-zones/terraform-oci-modules-iam//compartments?ref=v0.2.4"
  providers                  = { oci = oci }
  tenancy_ocid               = var.tenancy_ocid
  compartments_configuration = local.enclosed_compartments_configuration
}

module "lz_policies" {
  depends_on             = [module.lz_compartments, oci_identity_domains_group.deploy]
  source                 = "github.com/oci-landing-zones/terraform-oci-modules-iam//policies?ref=v0.2.4"
  providers              = { oci = oci }
  tenancy_ocid           = var.tenancy_ocid
  policies_configuration = local.policies_configuration
}


resource "oci_identity_domains_group" "deploy" {
  depends_on = [oci_identity_domains_user.svc_user]
  #Required
  display_name  = local.deploy_group_name
  idcs_endpoint = var.default_domain_url
  schemas       = ["urn:ietf:params:scim:schemas:core:2.0:Group"]
  members {
    #Required
    type  = "User"
    value = oci_identity_domains_user.svc_user.id
  }

}

locals {
  cmps_defined_tags = null
  cmps_freeform_tags = {
    apm : "${var.app_name}",
    application_name : "${var.full_application_name}",
    business_product : "${var.business_product}",
    compliance : "${var.compliance}",
    data_classification : "${var.data_classification}",
    env : "${var.env}",
    risk_score : "${var.risk_score}",
    support_team_email : "${var.support_team_email}",
    system_class_tier : "${var.system_class_tier}"
  }
  groups_defined_tags    = null
  groups_freeform_tags   = null
  policies_defined_tags  = null
  policies_freeform_tags = null

  # compartment
  app_compartment_name = "cmp${var.app_name}"
  app_cmp = {
    ("APP_CMP") : {
      name : "${local.app_compartment_name}",
      description : "Application ${var.app_name} Compartment",
      defined_tags : local.cmps_defined_tags,
      freeform_tags : local.cmps_freeform_tags
      children : {}
    }
  }
  network_compartment_name  = "ej-network-cmp"
  security_compartment_name = "ej-security-cmp"

  all_enclosed_compartments = merge(local.app_cmp)

  env_container_cmp_id = var.env == "prod" ? var.prod_compartment_id : var.non_prod_compartment_id
  enclosed_compartments_configuration = {
    default_parent_id : local.env_container_cmp_id
    compartments : local.all_enclosed_compartments
  }

  # groups
  # mapped to entraid
  # TODO add mapping code
  #devops_group_name = "ej-devops-${var.app_name}-grp"
  devops_group_name = var.devops-group-name
  /*
  devops_group = {
    ("DEVOPS_GROUP") = {
      name          = "${local.devops_group_name}"
      description   = "DEVOPS group for application ${var.app_name}"
      members       = []
      defined_tags  = local.groups_defined_tags
      freeform_tags = local.groups_freeform_tags
    }
  }*/


  # local group
  # contains one local user with an api key.
  # that user will not have console ui capability.. no access to console
  # supply public key as input
  deploy_group_name = "grp-${var.app_name}-deploy"
  /*
  deploy_group = {
    ("DEPLOY_GROUP") = {
      name          = "${local.deploy_group_name}"
      description   = "DEPLOY group for application ${var.app_name}"
      #members       = [oci_identity_domains_user.svc_user.id]
      memebers=["12121"]
      defined_tags  = local.groups_defined_tags
      freeform_tags = local.groups_freeform_tags
    }
  }*/

  /*
  groups_configuration = {
    groups : merge(local.devops_group)
  }*/

  env_container_cmp = var.env != "prod" ? "ej-app-non-prod-cmp" : "ej-app-prod-cmp"

  ###########################################################################
  ## (ONE) deploy group grants on APP compartment
  ###########################################################################

  deploy_grants_on_app_cmp = [
    "allow group ${local.deploy_group_name} to read all-resources in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage functions-family in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage api-gateway-family in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage ons-family in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage streams in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage cluster-family in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage alarms in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage metrics in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage logging-family in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage instance-family in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    # CIS 1.2 - 1.14 Level 2
    "allow group ${local.deploy_group_name} to manage volume-family in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
    "allow group ${local.deploy_group_name} to manage object-family in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
    "allow group ${local.deploy_group_name} to manage file-family in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
    "allow group ${local.deploy_group_name} to manage repos in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage orm-stacks in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage orm-jobs in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage orm-config-source-providers in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to read audit-events in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to read work-requests in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage bastion-session in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage cloudevents-rules in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage instance-agent-plugins in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage keys in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to use key-delegate in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage secret-family in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    # changed this as deploy group will assume manage db role as well, until we separate it out into a separate group.
    "allow group ${local.deploy_group_name} to manage autonomous-database-family in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
    "allow group ${local.deploy_group_name} to manage database-family in compartment ${local.env_container_cmp}:${local.app_compartment_name}"
  ]
  ## deploy grants on Network compartment
  deploy_grants_on_network_cmp = [
    "allow group ${local.deploy_group_name} to read virtual-network-family in compartment ${local.network_compartment_name}",
    "allow group ${local.deploy_group_name} to use subnets in compartment ${local.network_compartment_name}",
    "allow group ${local.deploy_group_name} to use network-security-groups in compartment ${local.network_compartment_name}",
    "allow group ${local.deploy_group_name} to use vnics in compartment ${local.network_compartment_name}",
    "allow group ${local.deploy_group_name} to manage private-ips in compartment ${local.network_compartment_name}",
    "allow group ${local.deploy_group_name} to use load-balancers in compartment ${local.network_compartment_name}"
  ]
  ## deploy grants on Security compartment
  deploy_grants_on_security_cmp = [
    "allow group ${local.deploy_group_name} to use vaults in compartment ${local.security_compartment_name}",
    "allow group ${local.deploy_group_name} to inspect keys in compartment ${local.security_compartment_name}",
    "allow group ${local.deploy_group_name} to manage instance-images in compartment ${local.security_compartment_name}",
    "allow group ${local.deploy_group_name} to read vss-family in compartment ${local.security_compartment_name}",
    "allow group ${local.deploy_group_name} to use bastion in compartment ${local.security_compartment_name}",
    "allow group ${local.deploy_group_name} to manage bastion-session in compartment ${local.security_compartment_name}",
    "allow group ${local.deploy_group_name} to read logging-family in compartment ${local.security_compartment_name}"
  ]

  ## deploy grants on Enclosing Compartment
  deploy_grants_on_enclosing_cmp = [
    "allow group ${local.deploy_group_name} to read app-catalog-listing in compartment ${var.enclosing_compartment_name}",
    "allow group ${local.deploy_group_name} to read instance-images in compartment ${var.enclosing_compartment_name}",
    "allow group ${local.deploy_group_name} to read repos in compartment ${var.enclosing_compartment_name}"
  ]

  ## All deploy grants
  deploy_grants = concat(local.deploy_grants_on_app_cmp, local.deploy_grants_on_security_cmp, local.deploy_grants_on_network_cmp, local.deploy_grants_on_enclosing_cmp)


  ###################################################################################
  ## (TWO) devops group grants on app compartment
  ## this is what accenture will be using
  ## ADD LZ app admin template policies....
  ###################################################################################
  # default
  devops_grants_on_app_cmp = [
    "allow group ${local.devops_group_name} to use all-resources in compartment ${local.env_container_cmp}:${local.app_compartment_name}"
  ]

  ## All devops grants INCLUDING Custom Application-specific policies picked up from key-map in custom policies file...
  custom_policies = try(local.devops_grants_on_app_cmp_custom["${var.app_name}"], null)
  devops_grants = concat(local.devops_grants_on_app_cmp, local.custom_policies == null? []: local.custom_policies )


  ###################################################################################
  ## (THREE) setup policy configuration
  ###################################################################################

  app_policies_in_enclosing_cmp = {
    ("ej-devops-policy") = {
      compartment_id = var.enclosing_compartment_id
      name           = "policy-${var.app_name}-devops"
      description    = "LZ policy for ${local.devops_group_name} group to use infrastructure in compartment ${local.env_container_cmp}:${local.app_compartment_name}."
      defined_tags   = local.policies_defined_tags
      freeform_tags  = local.policies_freeform_tags
      statements     = local.devops_grants
    },
    ("ej-deploy-policy") = {
      compartment_id = var.enclosing_compartment_id
      name           = "policy-${var.app_name}-deploy"
      description    = "LZ policy for ${local.deploy_group_name} group to manage infrastructure in compartment ${local.env_container_cmp}:${local.app_compartment_name}."
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

