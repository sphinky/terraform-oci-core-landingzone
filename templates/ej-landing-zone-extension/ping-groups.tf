

module "lz_custom_ping_domain_groups" {
  source                               = "github.com/oci-landing-zones/terraform-oci-modules-iam//identity-domains?ref=v0.2.4"
  count                                = 1
  providers                            = { oci = oci }
  tenancy_ocid                         = local.tenancy_ocid
  identity_domain_groups_configuration = local.groups_configuration
}

locals {

  ping_groups_defined_tags  = null
  ping_groups_freeform_tags = null

  ## Enter here the OCID of the secondary domain
  custom_id_domain_ocid = "ocid1.domain.oc1..aaaaaaaa2g2kivhaznefs5cx7vxfdxwzrmb5hafk7iagao53nyvo5l24vtma"

  #--------------------------------------------------------------------
  #-- OIC Service Admin
  #--------------------------------------------------------------------
  oic_service_admin_group = {
    # make sure that this  key is unique; and that the group name is unique as well....
    ("OIC-SERVICE-ADMIN-GROUP") = {
      identity_domain_id = trimspace(local.custom_id_domain_ocid)
      name               = "oic-service-admin-group"
      description        = "OIC service admin group."
      members            = []
      defined_tags       = local.ping_groups_defined_tags
      freeform_tags      = local.ping_groups_freeform_tags
    }
  }

  #--------------------------------------------------------------------
  #-- OIC Service Deployer
  #--------------------------------------------------------------------
  oic_service_deployer_group = {
    ("OIC-SERVICE-DEPLOYER-GROUP") = {
      identity_domain_id = trimspace(local.custom_id_domain_ocid)
      name               = "oic-service-deployer-group"
      description        = "OIC service deployer group."
      members            = []
      defined_tags       = local.ping_groups_defined_tags
      freeform_tags      = local.ping_groups_freeform_tags
    }
  }

  #--------------------------------------------------------------------
  #-- OIC Service User
  #--------------------------------------------------------------------
  oic_service_user_group = {
    ("OIC-SERVICE-USER-GROUP") = {
      identity_domain_id = trimspace(local.custom_id_domain_ocid)
      name               = "oic-service-user-group"
      description        = "OIC service user group."
      members            = []
      defined_tags       = local.ping_groups_defined_tags
      freeform_tags      = local.ping_groups_freeform_tags
    }
  }

  #--------------------------------------------------------------------
  #-- OIC Service Monitor
  #--------------------------------------------------------------------
  oic_service_monitor_group = {
    ("OIC-SERVICE-USER-GROUP") = {
      identity_domain_id = trimspace(local.custom_id_domain_ocid)
      name               = "oic-service-monitor-group"
      description        = "OIC service monitor group."
      members            = []
      defined_tags       = local.ping_groups_defined_tags
      freeform_tags      = local.ping_groups_freeform_tags
    }
  }


  # reference each new group variable here in the merge
  groups_configuration = {
    groups : merge(local.oic_service_admin_group, local.oic_service_deployer_group, local.oic_service_admin_group, local.oic_service_monitor_group)
  }

}
