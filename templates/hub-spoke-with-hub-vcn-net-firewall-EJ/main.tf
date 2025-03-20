# Copyright (c) 2024, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# ----------------------------------------------------------------------------------------
# -- This configuration deploys a CIS compliant landing zone with custom VCN settings.
# -- See other templates for other CIS compliant landing zones with alternative settings.
# -- 1. Rename this file to main.tf. 
# -- 2. Provide/review the variable assignments below.
# -- 3. In this folder, execute the typical Terraform workflow:
# ----- $ terraform init
# ----- $ terraform plan
# ----- $ terraform apply
# ----------------------------------------------------------------------------------------

module "core_lz" {
  source = "../../"

  # ------------------------------------------------------
  # ----- Environment
  # ------------------------------------------------------
  tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaavsncoxsayjosdkgpbba773vuk72ihrwgumz7vvy54f27pdqxtauq" # Replace with your tenancy OCID.
  user_ocid            = "ocid1.user.oc1..aaaaaaaa5efwa7mi2w2weijre43kwyfad2xxklbehkyonhep6q5skjprgsfa"    # Replace with your user OCID.
  fingerprint          = "7b:41:37:c8:03:be:58:6c:f7:de:e4:f2:23:61:92:50"                                 # Replace with user fingerprint.
  private_key_path     = "../../../../../../mreabdelhalim@gmail.com_2025-03-03T22_59_30.190Z.pem"          # Replace with user private key local path.
  private_key_password = ""
  # private_key        = ""                                                                                # Replace with user private key.

  region        = "uk-london-1" # Replace with region name.
  service_label = "ej"          # Prefix prepended to deployed resource names. 

  enclosing_compartment_parent_ocid = "ocid1.compartment.oc1..aaaaaaaaw47psqasz6loxjcbv2qixewgigq5tbvnsuhldj5rclrhsf54kwxa"

  # ------------------------------------------------------
  # ----- Group Mappings
  # ------------------------------------------------------
  # Replace with OCIDs of existing groups, once they're SCIMed over from EntraId
  customize_iam                              = true
  groups_options                             = "No, use existing"
  rm_existing_iam_admin_group_name           = "ocid1.group.oc1..aaaaaaaanu4eqf6izohqfluwcqsxpj24pnmsq46rrns26yexn32ef377eq7q"
  rm_existing_cost_admin_group_name          = "ocid1.group.oc1..aaaaaaaanu4eqf6izohqfluwcqsxpj24pnmsq46rrns26yexn32ef377eq7q"
  rm_existing_cred_admin_group_name          = "ocid1.group.oc1..aaaaaaaanu4eqf6izohqfluwcqsxpj24pnmsq46rrns26yexn32ef377eq7q"
  #rm_existing_security_admin_group_name      = "ocid1.group.oc1..aaaaaaaanu4eqf6izohqfluwcqsxpj24pnmsq46rrns26yexn32ef377eq7q"
  rm_existing_ag_admin_group_name            = "ocid1.group.oc1..aaaaaaaanu4eqf6izohqfluwcqsxpj24pnmsq46rrns26yexn32ef377eq7q"
  rm_existing_network_admin_group_name       = "ocid1.group.oc1..aaaaaaaanu4eqf6izohqfluwcqsxpj24pnmsq46rrns26yexn32ef377eq7q"
  #rm_existing_appdev_admin_group_name       = "ocid1.group.oc1..aaaaaaaanu4eqf6izohqfluwcqsxpj24pnmsq46rrns26yexn32ef377eq7q"
  rm_existing_auditor_group_name             = "ocid1.group.oc1..aaaaaaaanu4eqf6izohqfluwcqsxpj24pnmsq46rrns26yexn32ef377eq7q"
  rm_existing_announcement_reader_group_name = "ocid1.group.oc1..aaaaaaaanu4eqf6izohqfluwcqsxpj24pnmsq46rrns26yexn32ef377eq7q"
  rm_existing_storage_admin_group_name       = "ocid1.group.oc1..aaaaaaaanu4eqf6izohqfluwcqsxpj24pnmsq46rrns26yexn32ef377eq7q"

  # ------------------------------------------------------
  # ----- Networking
  # ------------------------------------------------------
  # onprem_cidrs = ["0.0.0.0/0"]
  define_net            = true # enables network resources provisioning
  hub_deployment_option = "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)"

  # --- Firewall deployment options.
  hub_vcn_deploy_net_appliance_option = "Don't deploy any network appliance at this time"
  enable_native_firewall_threat_log   = true
  enable_native_firewall_traffic_log  = true
  oci_nfw_ip_ocid                     = "ocid1.privateip.oc1.uk-london-1.abwgiljtv2hzcgkadps2my3xw5ct5sxh7tmti23zzvduwph3a2xjeiigdj4a" 
  # oci_nfw_policy_ocid               = ["ocid1.networkfirewallpolicy.oc1.phx.amaaaa...gmm"] from user created network firewall policy

  # --- Hub VCN: 	
  customize_hub_vcn_subnets                           = true
  hub_vcn_name                                        = "dmz-hub-vcn"
  hub_vcn_cidrs                                       = ["172.28.96.0/22"]
  hub_vcn_web_subnet_is_private                       = true
  hub_vcn_web_subnet_name                             = "dmz-untrust-snet"
  hub_vcn_mgmt_subnet_name                            = "dmz-mgmt-snet"
  hub_vcn_outdoor_subnet_name                         = "dmz-ha-snet"
  hub_vcn_indoor_subnet_name                          = "dmz-trust-snet"
  hub_vcn_web_subnet_cidr                             = "172.28.96.0/24"
  hub_vcn_mgmt_subnet_cidr                            = "172.28.99.0/24"
  hub_vcn_outdoor_subnet_cidr                         = "172.28.98.0/24"
  hub_vcn_indoor_subnet_cidr                          = "172.28.97.0/24"
  hub_vcn_mgmt_subnet_external_allowed_cidrs_for_http = []
  hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh  = []

  # --- Spoke 1 VCN: three-tier VCN 1	
  add_tt_vcn1               = true
  tt_vcn1_name              = "prod-shared-vcn"
  tt_vcn1_attach_to_drg     = true
  tt_vcn1_cidrs             = ["172.28.104.0/25"]
  customize_tt_vcn1_subnets = true
  tt_vcn1_web_subnet_name   = "shared-web-snet"
  tt_vcn1_app_subnet_name   = "shared-app-snet"
  tt_vcn1_db_subnet_name    = "shared-db-snet"
  tt_vcn1_web_subnet_cidr   = "172.28.104.0/27"
  tt_vcn1_app_subnet_cidr   = "172.28.104.64/27"
  tt_vcn1_db_subnet_cidr    = "172.28.104.32/27"

  # --- Spoke 2 VCN: three-tier VCN 2	
  add_tt_vcn2               = true
  tt_vcn2_name              = "dev-internal-vcn"
  tt_vcn2_attach_to_drg     = true
  tt_vcn2_cidrs             = ["172.28.105.0/24"]
  customize_tt_vcn2_subnets = true
  tt_vcn2_web_subnet_name   = "dev-web-snet"
  tt_vcn2_app_subnet_name   = "dev-app-snet"
  tt_vcn2_db_subnet_name    = "dev-db-snet"
  tt_vcn2_web_subnet_cidr   = "172.28.105.0/26"
  tt_vcn2_app_subnet_cidr   = "172.28.105.128/26"
  tt_vcn2_db_subnet_cidr    = "172.28.105.64/26"

 #--- Spoke 3 VCN: three-tier VCN 3	
  add_tt_vcn3               = true
  tt_vcn3_name              = "prod-internal-vcn"
  tt_vcn3_attach_to_drg     = true
  tt_vcn3_cidrs             = ["172.28.106.0/24"]
  customize_tt_vcn3_subnets = true
  tt_vcn3_web_subnet_name   = "prod-web-snet"
  tt_vcn3_app_subnet_name   = "prod-app-snet"
  tt_vcn3_db_subnet_name    = "prod-db-snet"
  tt_vcn3_web_subnet_cidr   = "172.28.106.0/26"
  tt_vcn3_app_subnet_cidr   = "172.28.106.128/26"
  tt_vcn3_db_subnet_cidr    = "172.28.106.64/26"

  #--- Spoke 4 VCN: three-tier VCN 4	
  add_tt_vcn4               = true
  tt_vcn4_name              = "clone-internal-vcn"
  tt_vcn4_attach_to_drg     = true
  tt_vcn4_cidrs             = ["172.28.107.0/24"]
  customize_tt_vcn4_subnets = true
  tt_vcn4_web_subnet_name   = "dev-web-snet"
  tt_vcn4_app_subnet_name   = "dev-app-snet"
  tt_vcn4_db_subnet_name    = "dev-db-snet"
  tt_vcn4_web_subnet_cidr   = "172.28.107.0/26"
  tt_vcn4_app_subnet_cidr   = "172.28.107.128/26"
  tt_vcn4_db_subnet_cidr    = "172.28.107.64/26"

  # ------------------------------------------------------
  # ----- Notifications
  # ------------------------------------------------------
  network_admin_email_endpoints  = ["steve.conner@edwardjonesxyz.com", "cloud-platform@edwardjonesxyz.coms"]
  security_admin_email_endpoints = ["cloud-platform@edwardjonesxyz.coms"]

  # ------------------------------------------------------
  # ----- Security
  # ------------------------------------------------------
  enable_cloud_guard            = false
  enable_service_connector      = true
  service_connector_target_kind = "streaming"
}
