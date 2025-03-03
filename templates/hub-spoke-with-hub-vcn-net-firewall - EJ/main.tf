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
    tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaa...3jb"               # Replace with your tenancy OCID.
    user_ocid            = "ocid1.user.oc1..aaaaaaaa...xsb"                  # Replace with your user OCID.
    fingerprint          = "19:42:xx:92:yy:b3:zz:2f:aa:ea:bb:59:cc:be:dd:ba" # Replace with user fingerprint.
    private_key_path     = "path-to-pem-file-with-private-key"               # Replace with user private key local path.
    private_key_password = ""                                                # Replace with private key password, if any.
    region               = "us-phoenix-1" # Replace with region name.
    service_label        = "ej"     # Prefix prepended to deployed resource names. 
  	

    enclosing_compartment_parent_ocid	="ocid1.tenancy.oc1..aaaaaaaavsncoxsayjosdkgpbba773vuk72ihrwgumz7vvy54f27pdqxtauq"	

    # ------------------------------------------------------
    # ----- Networking
    # ------------------------------------------------------
    define_net            = true # enables network resources provisioning
 

    customize_iam=	true	

    groups_options	="No, use existing"	

    hub_deployment_option	="VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)"	

    onprem_cidrs=	["0.0.0.0/0"]	

    hub_vcn_name=	"dmz-hub-vcn"	

    hub_vcn_cidrs	=["172.28.96.0/22"]	

    # --- Firewall deployment options.
    #hub_vcn_deploy_net_appliance_option = "OCI Native Firewall"
    
    # oci_nfw_ip_ocid                   = ["ocid1.privateip.oc1.phx.abyhql...goq"] as determined after the initial Terraform Apply
    # oci_nfw_policy_ocid               = ["ocid1.networkfirewallpolicy.oc1.phx.amaaaa...gmm"] from user created network firewall policy

    hub_vcn_deploy_net_appliance_option	="OCI Native Firewall"	

    enable_native_firewall_threat_log	=true	

    enable_native_firewall_traffic_log	=true	

    customize_hub_vcn_subnets	=true	

    hub_vcn_web_subnet_name	="dmz-untrust-snet"	

    hub_vcn_web_subnet_is_private	=true	

    hub_vcn_mgmt_subnet_name	="dmz-mgmt-snet"

    hub_vcn_mgmt_subnet_external_allowed_cidrs_for_http	=[]	

    hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh	=[]


    hub_vcn_outdoor_subnet_name	="dmz-ha-snet"	
    hub_vcn_indoor_subnet_name	="dmz-trust-snet"
    
    # --- Spoke VCN: three-tier VCN 1	
    add_tt_vcn1	=true	
    tt_vcn1_name	="prod-shared-vcn"	
    tt_vcn1_cidrs	=["172.28.104.0/24"]	
    customize_tt_vcn1_subnets=	true	
    tt_vcn1_web_subnet_name	="shared-web-snet"	
    tt_vcn1_app_subnet_name	="shared-app-snet"	
    tt_vcn1_db_subnet_name	="shared-db-snet"
    
    # --- Spoke VCN: three-tier VCN 2	

    add_tt_vcn2	=true	
    tt_vcn2_name	="dev-internal-vcn"	
    tt_vcn2_cidrs=	[]	
    customize_tt_vcn2_subnets=	true	
    tt_vcn2_web_subnet_name	="dev-web-snet"	
    tt_vcn2_app_subnet_name=	"dev-app-snet"	
    tt_vcn2_db_subnet_name	="dev-db-snet"	

    # ------------------------------------------------------
    # ----- Notifications
    # ------------------------------------------------------
    #network_admin_email_endpoints  = ["email.address@example.com"] # for network-related events. Replace with a real email address.
    #security_admin_email_endpoints = ["email.address@example.com"] # for security-related events. Replace with a real email address.
    network_admin_email_endpoints	=["steve.conner@edwardjones.com","cloud-platform@edwardjones.com"]	
    security_admin_email_endpoints=	["cloud-platform@edwardjones.com"]	

    # ------------------------------------------------------
    # ----- Security
    # ------------------------------------------------------
    #enable_cloud_guard = false # Set to false if Cloud Guard has already been enabled.
    
    enable_cloud_guard=	false	
    
    enable_service_connector	=true

    service_connector_target_kind	="streaming"	
    tt_vcn1_attach_to_drg=	true	
    tt_vcn2_attach_to_drg	=true	
    hub_vcn_web_subnet_cidr	="172.28.96.0/24"	
    hub_vcn_mgmt_subnet_cidr	="172.28.99.0/24"	
    hub_vcn_outdoor_subnet_cidr=	"172.28.98.0/24"
    hub_vcn_indoor_subnet_cidr=	"172.28.97.0/24"	
    tt_vcn1_web_subnet_cidr	="172.28.104.0/26"	
    tt_vcn1_app_subnet_cidr	="172.28.104.128/26"	
    tt_vcn1_db_subnet_cidr	="172.28.104.64/26"	
    tt_vcn2_web_subnet_cidr	="172.28.105.0/26"
    tt_vcn2_db_subnet_cidr	="172.28.105.64/26"

}
