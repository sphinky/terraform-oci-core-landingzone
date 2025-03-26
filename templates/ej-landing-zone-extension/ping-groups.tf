


module "lz_groups" {
  source               = "github.com/oci-landing-zones/terraform-oci-modules-iam//groups?ref=v0.2.7"
  count                = 1
  providers            = { oci = oci.home }
  tenancy_ocid         = local.tenancy_ocid
  groups_configuration = local.groups_configuration
}



locals {
  groups_defined_tags  = null
  groups_freeform_tags = null

  #--------------------------------------------------------------------
  #-- OIC Service Admin
  #--------------------------------------------------------------------


  oic_service_admin_group = {
    # make sure that this  key is unique; and that the group name is unique as well....
    ("OIC-SERVICE-ADMIN-GROUP") = {
      name          = "oic-service-admin-group"
      description   = "OIC service admin group."
      members       = []
      defined_tags  = local.groups_defined_tags
      freeform_tags = local.groups_freeform_tags
    }
  }

  #--------------------------------------------------------------------
  #-- OIC Service Deployer
  #--------------------------------------------------------------------


  oic_service_deployer_group = {
    ("OIC-SERVICE-DEPLOYER-GROUP") = {
      name          = "oic-service-deployer-group"
      description   = "OIC service deployer group."
      members       = []
      defined_tags  = local.groups_defined_tags
      freeform_tags = local.groups_freeform_tags
    }
  }

  #--------------------------------------------------------------------
  #-- OIC Service User
  #--------------------------------------------------------------------


  oic_service_user_group = {
    ("OIC-SERVICE-USER-GROUP") = {
      name          = "oic-service-user-group"
      description   = "OIC service user group."
      members       = []
      defined_tags  = local.groups_defined_tags
      freeform_tags = local.groups_freeform_tags
    }
  }


  groups_configuration = {
    groups : merge(local.oic_service_admin_group, local.oic_service_deployer_group, local.oic_service_admin_group)
  }

}
