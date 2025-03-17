locals {
  devops_grants_on_app_cmp_custom = {
    
    # these are the custom policies of the IDM application (05000)
    ("5000pr01") = [
      
      "Allow group ${local.devops_group_name} to manage volume-family in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all {request.permission!='VOLUME_DELETE',request.permission!='VOLUME_CREATE'}",
      "Allow group ${local.devops_group_name} to manage instance-family in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all {request.permission!='INSTANCE_DELETE',request.permission!='INSTANCE_CREATE' }",
      "Allow group ${local.devops_group_name} to manage object-family in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all {request.permission!='BUCKET_DELETE',request.permission!='BUCKET_CREATE' }",
      "Allow group ${local.devops_group_name} to manage autonomous-database-family in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all {request.permission!='AUTONOMOUS_DATABASE_DELETE',request.permission!='AUTONOMOUS_DATABASE_CREATE' }",
      "Allow group ${local.devops_group_name} to inspect work-requests in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
      "Allow group ${local.devops_group_name} to manage objectstorage-private-endpoint in compartment ${local.env_container_cmp}:${local.app_compartment_name}"
    ],
    # these are the custom policies of the OIC application (05004)
    ("5004dv01") = [
      "Allow group  ${local.devops_group_name} to manage volume-family in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all {request.permission!='VOLUME_DELETE',request.permission!='VOLUME_CREATE' }",
      "Allow group  ${local.devops_group_name} to manage instance-family in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all {request.permission!='INSTANCE_DELETE',request.permission!='INSTANCE_CREATE' }",
      "Allow group  ${local.devops_group_name} to manage object-family in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all {request.permission!='BUCKET_DELETE',request.permission!='BUCKET_CREATE' }",
      "Allow group  ${local.devops_group_name} to manage autonomous-database-family in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all {request.permission!='AUTONOMOUS_DATABASE_DELETE',request.permission!='AUTONOMOUS_DATABASE_CREATE' }",
      "Allow group  ${local.devops_group_name} to manage integration-instance in compartment ${local.env_container_cmp}:${local.app_compartment_name} where all {request.permission!='INTEGRATION_INSTANCE_DELETE',request.permission!='INTEGRATION_INSTANCE_CREATE' }",
      "Allow group  ${local.devops_group_name} to inspect work-requests in compartment ${local.env_container_cmp}:${local.app_compartment_name}",
      "Allow group  ${local.devops_group_name} to manage visualbuilder-instance in compartment ${local.env_container_cmp}:${local.app_compartment_name} where request.permission!='VISUALBUILDER_INSTANCE_DELETE'",
      "Allow group  ${local.devops_group_name} to manage process-automation-instance in compartment ${local.env_container_cmp}:${local.app_compartment_name} where request.permission!='PROCESS_AUTOMATION_INSTANCE_DELETE'",
      "Allow group  ${local.devops_group_name} to manage objectstorage-private-endpoint in compartment ${local.env_container_cmp}:${local.app_compartment_name}"
    ]

  }
}


