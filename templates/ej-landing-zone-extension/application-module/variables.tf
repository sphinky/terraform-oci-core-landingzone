## this is the app name.. it will be part of the created compartment name.
## the generated container compartment will have the name ej-app-${app_name}-cmp
## don't use underscores in the name.. better use dashes.
variable "app_name" {
  type = string
}

## the enclosing compartment is the compartment that 'encloses' the landding zone.. in our case the ej-top-cmp.
variable "enclosing_compartment_id" {
  type = string
}

variable "enclosing_compartment_name" {
  type = string
}

variable "prod_compartment_id" {
  type = string
}

variable "non_prod_compartment_id" {
  type = string
}

variable "svc_user_public_key" {
  type = string
}

variable "default_domain_url" {
  type = string
}

variable "env" {
  type = string
  # "prod" or "non-prod" 
}

variable "tenancy_ocid" {
  type = string
}

#mapping to existing devops group
variable "devops_group_name" {
  type = string
}

#These are the tag values attached to the application compartment
variable "full_application_name" {
  type = string
}

variable "business_product" {
  type = string
}

variable "compliance" {
  type = string
}

variable "data_classification" {
  type = string
}

variable "risk_score" {
  type = string
}

variable "support_team_email" {
  type = string
}

variable "system_class_tier" {
  type = string
}
