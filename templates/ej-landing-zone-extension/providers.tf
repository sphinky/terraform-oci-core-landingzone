# ------------------------------------------------------
# ----- Environment
# ------------------------------------------------------
locals {
  tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaavsncoxsayjosdkgpbba773vuk72ihrwgumz7vvy54f27pdqxtauq" # Replace with your tenancy OCID.
  user_ocid            = "ocid1.user.oc1..aaaaaaaa5efwa7mi2w2weijre43kwyfad2xxklbehkyonhep6q5skjprgsfa"    # Replace with your user OCID.
  fingerprint          = "7b:41:37:c8:03:be:58:6c:f7:de:e4:f2:23:61:92:50"                                 # Replace with user fingerprint.
  private_key_path     = "../../../../../../mreabdelhalim@gmail.com_2025-03-03T22_59_30.190Z.pem"          # Replace with user private key local path.
  private_key_password = ""
  # private_key        = ""    # Replace with user private key.
  region = "uk-london-1"
}

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
