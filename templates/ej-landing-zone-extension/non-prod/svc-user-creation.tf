resource "oci_identity_domains_user" "svc_user" {
    #Required
    idcs_endpoint = local.default_domain_url
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:User"]
    user_name = "svc-deploy-user-${var.app_name}"
    /* Note: In most cases, a primary email is REQUIRED to create a user. Otherwise you might get a 400 error. Please see "emails" block below. */

    #Optional
    active = true
    
    attribute_sets = []
    attributes = ""
    description = "deploy user"
    display_name = "deploy-user-${var.app_name}"

    /* One and only one "emails" block needs to have "primary" set to true */
    emails {
        #Required
        type = var.user_emails_type
        value = var.user_emails_value

        #Optional
        primary = true
        secondary = true
        verified = true
    }
    
    external_id = "externalId"
    
    id = var.user_id
    
    ims {
        #Required
        type = var.user_ims_type
        value = var.user_ims_value

    }
    
    urnietfparamsscimschemasoracleidcsextensioncapabilities_user {

        #Optional
        can_use_api_keys = true
        can_use_auth_tokens = false
        can_use_console_password = false
        can_use_customer_secret_keys = false
        can_use_db_credentials = false
        can_use_oauth2client_credentials = false
        can_use_smtp_credentials = false
    } 
    
  
}

resource "oci_identity_domains_my_api_key" "test_my_api_key" {
    #Required
    idcs_endpoint = data.oci_identity_domain.test_domain.url
    key = var.my_api_key_key
    schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:apikey"]

    #Optional
    authorization = var.my_api_key_authorization
    description = var.my_api_key_description
    id = var.my_api_key_id
    ocid = var.my_api_key_ocid
    resource_type_schema_version = var.my_api_key_resource_type_schema_version
    tags {
        #Required (that's the public key we need to upload)
        key = var.my_api_key_tags_key
        value = var.my_api_key_tags_value
    }
    user {

        #Optional
        ocid = var.my_api_key_user_ocid
        value = var.my_api_key_user_value
    }
}