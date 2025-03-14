resource "oci_identity_domains_user" "svc_user" {

  #depends_on = [module.lz_groups] ### Explicitly declaring dependencies on the group and compartments modules.
  #Required
  idcs_endpoint = var.default_domain_url
  schemas       = ["urn:ietf:params:scim:schemas:core:2.0:User"]
  user_name     = "deploy-user-${var.app_name}"
  /* Note: In most cases, a primary email is REQUIRED to create a user. Otherwise you might get a 400 error. Please see "emails" block below. */

  #Optional
  #active = true
  name {
    #Required
    family_name = "reagan"
    given_name  = "ronald"

  }
  description  = "deploy user"
  display_name = "deploy-user-${var.app_name}"

  /* One and only one "emails" block needs to have "primary" set to true */
  emails {
    #Required
    type  = "work"
    value = "mreabdelhalim@gmail.com"

    #Optional
    primary = true
  }

  urnietfparamsscimschemasoracleidcsextensioncapabilities_user {
    #Optional
    # this means that this svc user ONLY can use API keys... 
    can_use_api_keys                 = true
    can_use_auth_tokens              = false
    can_use_console_password         = false
    can_use_customer_secret_keys     = false
    can_use_db_credentials           = false
    can_use_oauth2client_credentials = false
    can_use_smtp_credentials         = false
  }
}

resource "oci_identity_domains_api_key" "test_my_api_key" {
  depends_on = [oci_identity_domains_user.svc_user]
  #Required
  idcs_endpoint = var.default_domain_url
  key           = var.svc_user_public_key
  schemas       = ["urn:ietf:params:scim:schemas:oracle:idcs:apikey"]

  user {
    #Optional
    ocid  = oci_identity_domains_user.svc_user.ocid
    value = oci_identity_domains_user.svc_user.id
  }
}
