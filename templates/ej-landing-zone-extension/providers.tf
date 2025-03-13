# ------------------------------------------------------
# ----- Environment
# ------------------------------------------------------


provider "oci" {
  region           = local.region
  tenancy_ocid     = local.tenancy_ocid
  user_ocid        = local.user_ocid
  fingerprint      = local.fingerprint
  private_key_path = local.private_key_path
  #private_key           = local.private_key
  ignore_defined_tags = ["Oracle-Tags.CreatedBy", "Oracle-Tags.CreatedOn"]
}

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    oci = {
      source = "oracle/oci"
      #configuration_aliases = [oci.home]
    }
  }
}
