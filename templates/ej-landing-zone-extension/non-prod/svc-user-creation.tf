resource "oci_identity_domains_user" "svc_user" {
    #Required
    idcs_endpoint = data.oci_identity_domain.test_domain.url
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:User"]
    user_name = "svc-deploy-user-${var.app_name}"
    /* Note: In most cases, a primary email is REQUIRED to create a user. Otherwise you might get a 400 error. Please see "emails" block below. */

    #Optional
    active = var.user_active
    addresses {
        #Required
        type = var.user_addresses_type

        #Optional
        country = var.user_addresses_country
        formatted = var.user_addresses_formatted
        locality = var.user_addresses_locality
        postal_code = var.user_addresses_postal_code
        primary = var.user_addresses_primary
        region = var.user_addresses_region
        street_address = var.user_addresses_street_address
    }
    attribute_sets = []
    attributes = ""
    description = var.user_description
    display_name = "deploy-user-${var.app_name}"

    /* One and only one "emails" block needs to have "primary" set to true */
    emails {
        #Required
        type = var.user_emails_type
        value = var.user_emails_value

        #Optional
        primary = true
        secondary = var.user_emails_secondary
        verified = var.user_emails_verified
    }
    /* Note:
      If a new user is created without a recovery email being set, we automatically add one using the primary email value,
      to ensure the account can be recovered (when account recovery feature is enabled in the current domain).
      So it is recommended to set an email of type "recovery" like below. If not, it is expected to see an update about 
      recovery email when plan/apply after creation.
    */
    emails {
        #Required
        type = "recovery"
        value = var.user_emails_value
    }
    entitlements {
        #Required
        type = var.user_entitlements_type
        value = var.user_entitlements_value

        #Optional
        display = var.user_entitlements_display
        primary = var.user_entitlements_primary
    }
    external_id = "externalId"
    id = var.user_id
    ims {
        #Required
        type = var.user_ims_type
        value = var.user_ims_value

        #Optional
        display = var.user_ims_display
        primary = var.user_ims_primary
    }
    locale = var.user_locale
    name {

        #Optional
        family_name = var.user_name_family_name
        formatted = var.user_name_formatted
        given_name = var.user_name_given_name
        honorific_prefix = var.user_name_honorific_prefix
        honorific_suffix = var.user_name_honorific_suffix
        middle_name = var.user_name_middle_name
    }
    nick_name = var.user_nick_name
    ocid = var.user_ocid
    password = var.user_password
    
   
    title = var.user_title
    
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
    
    user_type = var.user_user_type
  
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