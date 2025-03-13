module "lz_prod_identity_domain" {
  source                                       = "github.com/oci-landing-zones/terraform-oci-modules-iam//identity-domains?ref=v0.2.4"
  count                                        =  1 
  providers                                    = { oci = oci}
  tenancy_ocid                                 = local.tenancy_ocid
  identity_domains_configuration               = local.identity_domains_prod_configuration
  identity_domain_groups_configuration         = local.identity_domain_groups_prod_configuration
  identity_domain_dynamic_groups_configuration = local.identity_domain_dynamic_groups_prod_configuration
}

module "lz_dev_identity_domain" {
  source                                       = "github.com/oci-landing-zones/terraform-oci-modules-iam//identity-domains?ref=v0.2.4"
  count                                        =  1 
  providers                                    = { oci = oci }
  tenancy_ocid                                 = local.tenancy_ocid
  identity_domains_configuration               = local.identity_domains_dev_configuration
  identity_domain_groups_configuration         = local.identity_domain_groups_dev_configuration
  identity_domain_dynamic_groups_configuration = local.identity_domain_dynamic_groups_dev_configuration
}
module "lz_clone_identity_domain" {
  source                                       = "github.com/oci-landing-zones/terraform-oci-modules-iam//identity-domains?ref=v0.2.4"
  count                                        =  1 
  providers                                    = { oci = oci }
  tenancy_ocid                                 = local.tenancy_ocid
  identity_domains_configuration               = local.identity_domains_clone_configuration
  identity_domain_groups_configuration         = local.identity_domain_groups_clone_configuration
  identity_domain_dynamic_groups_configuration = local.identity_domain_dynamic_groups_clone_configuration
}

locals{
  new_identity_domain_license_type = "free"


identity_domains_prod_configuration = {
    identity_domains : {
      PROD-DOMAIN : {
        compartment_id                   = local.lz_security_compartment_id
        display_name                     = "ej-production-identity-domain"
        description                      = "identity domain for production workloads "
        license_type                     = local.new_identity_domain_license_type
        allow_signing_cert_public_access = false
      }
    }
  }
  identity_domain_groups_prod_configuration = {
    default_identity_domain_id : "PROD-DOMAIN"
    groups : null
  }

  identity_domain_dynamic_groups_prod_configuration = {
    default_identity_domain_id : "PROD-DOMAIN"
    dynamic_groups : null
  }

  identity_domains_dev_configuration = {
    identity_domains : {
      DEV-DOMAIN : {
        compartment_id                   = local.lz_security_compartment_id
        display_name                     = ej-dev-identity-domain
        description                      = "identity domain for development workloads"
        license_type                     = local.new_identity_domain_license_type
        allow_signing_cert_public_access = false
      }
    }
  }
  identity_domain_groups_dev_configuration = {
    default_identity_domain_id : "DEV-DOMAIN"
    groups : null
  }

  identity_domain_dynamic_groups_dev_configuration = {
    default_identity_domain_id : "DEV-DOMAIN"
    dynamic_groups : null
  }

  identity_domains_clone_configuration = {
    identity_domains : {
      CLONE-DOMAIN : {
        compartment_id                   = local.lz_security_compartment_id
        display_name                     = ej-clone-identity-domain
        description                      = "identity domain for clone workloads"
        license_type                     = local.new_identity_domain_license_type
        allow_signing_cert_public_access = false
      }
    }
  }
  identity_domain_groups_clone_configuration = {
    default_identity_domain_id : "CLONE-DOMAIN"
    groups : null
  }

  identity_domain_dynamic_groups_clone_configuration = {
    default_identity_domain_id : "CLONE-DOMAIN"
    dynamic_groups : null
  }

}

### TOD add domain configfuration