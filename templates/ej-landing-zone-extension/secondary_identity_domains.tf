module "lz_new_identity_domain" {
  source                                       = "github.com/oci-landing-zones/terraform-oci-modules-iam//identity-domains?ref=v0.2.4"
  count                                        =  1 
  providers                                    = { oci = oci.home }
  tenancy_ocid                                 = var.tenancy_ocid
  identity_domains_configuration               = local.identity_domains_configuration
  identity_domain_groups_configuration         = local.identity_domain_groups_configuration
  identity_domain_dynamic_groups_configuration = local.identity_domain_dynamic_groups_configuration
}