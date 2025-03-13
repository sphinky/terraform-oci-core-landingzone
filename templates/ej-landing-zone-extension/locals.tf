locals {
  tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaavsncoxsayjosdkgpbba773vuk72ihrwgumz7vvy54f27pdqxtauq" # Replace with your tenancy OCID.
  user_ocid            = "ocid1.user.oc1..aaaaaaaa5efwa7mi2w2weijre43kwyfad2xxklbehkyonhep6q5skjprgsfa"    # Replace with your user OCID.
  fingerprint          = "7b:41:37:c8:03:be:58:6c:f7:de:e4:f2:23:61:92:50"                                 # Replace with user fingerprint.
  private_key_path     = "../../../../../../mreabdelhalim@gmail.com_2025-03-03T22_59_30.190Z.pem"          # Replace with user private key local path.
  private_key_password = ""
  # private_key        = ""    # Replace with user private key.
  region                     = "uk-london-1"
  enclosing_compartment_id   = "ocid1.compartment.oc1..aaaaaaaaegil5on3wbgrupnprtd3swgws45kcmf2uaatmrxwj5ioidw6yf7a"  #that's top compartment of the landing zone
  lz_security_compartment_id = "ocid1.compartment.oc1..aaaaaaaapxcsokg3kxixulklpcxxodt74usex2dweihvhbsegzwgna2dkdfa"   #that's the comrpartment that will contain the secondary identity domains for keystone workloads
}
