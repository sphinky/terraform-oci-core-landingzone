locals {

  tt_3_jump_host_ingress_zpr_grants = local.add_tt_vcn3 && local.hub_with_drg_only && var.tt_vcn3_bastion_is_access_via_public_endpoint ? [
    for cidr in var.tt_vcn3_bastion_subnet_allowed_cidrs : "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow '${cidr}' to connect to ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints with protocol='tcp/22'"
  ] : []

  tt_3_hub_zpr_grants = local.add_tt_vcn3 && local.hub_with_vcn && var.tt_vcn3_attach_to_drg && var.deploy_bastion_jump_host ? [
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow '${coalesce(var.hub_vcn_jumphost_subnet_cidr, cidrsubnet(var.hub_vcn_cidrs[0], 3, 4))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/22'"
  ] : []

  tt_3_zpr_grants = local.add_tt_vcn3 ? concat([
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow ${local.zpr_namespace_name}.app:${local.zpr_label} endpoints to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow ${local.zpr_namespace_name}.bastion:${local.zpr_label} endpoints to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/22'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to 'osn-services-ip-addresses' with protocol='tcp/443'"
  ], local.tt_3_jump_host_ingress_zpr_grants) : []

  tt_3_to_tt_1_zpr_grants = (local.add_tt_vcn3 && local.add_tt_vcn1 && var.tt_vcn3_attach_to_drg && var.tt_vcn1_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "TT-VCN-1"))) ? [
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn1_db_subnet_cidr, cidrsubnet(var.tt_vcn1_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'"
  ] : []

  tt_3_to_tt_2_zpr_grants = (local.add_tt_vcn3 && local.add_tt_vcn2 && var.tt_vcn3_attach_to_drg && var.tt_vcn2_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "TT-VCN-2"))) ? [
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.tt_vcn2_db_subnet_cidr, cidrsubnet(var.tt_vcn2_cidrs[0], 4, 2))}' with protocol='tcp/1521-1522'"
  ] : []

  tt_3_to_exa_1_zpr_grants = (local.add_tt_vcn3 && local.add_exa_vcn1 && var.tt_vcn3_attach_to_drg && var.exa_vcn1_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "EXA-VCN-1"))) ? [
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow '${coalesce(var.exa_vcn1_client_subnet_cidr, cidrsubnet(var.exa_vcn1_cidrs[0], 4, 0))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} with protocol='tcp/1521-1522'"
  ] : []

  tt_3_to_exa_2_zpr_grants = (local.add_tt_vcn3 && local.add_exa_vcn2 && var.tt_vcn3_attach_to_drg && var.exa_vcn2_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "EXA-VCN-2"))) ? [
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow '${coalesce(var.exa_vcn2_client_subnet_cidr, cidrsubnet(var.exa_vcn2_cidrs[0], 4, 0))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} with protocol='tcp/1521-1522'"
  ] : []

  tt_3_to_exa_3_zpr_grants = (local.add_tt_vcn3 && local.add_exa_vcn3 && var.tt_vcn3_attach_to_drg && var.exa_vcn3_attach_to_drg) && (local.hub_with_drg_only == true && (length(var.tt_vcn3_routable_vcns) == 0 || contains(var.tt_vcn3_routable_vcns, "EXA-VCN-3"))) ? [
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow ${local.zpr_namespace_name}.database:${local.zpr_label} endpoints to connect to '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' with protocol='tcp/1521-1522'",
    "in ${local.zpr_namespace_name}.net:tt-vcn-3 VCN allow '${coalesce(var.exa_vcn3_client_subnet_cidr, cidrsubnet(var.exa_vcn3_cidrs[0], 4, 0))}' to connect to ${local.zpr_namespace_name}.database:${local.zpr_label} with protocol='tcp/1521-1522'"
  ] : []

  tt_3_zpr_policy = local.add_tt_vcn3 ? {
    ZPR-POLICY-TT-3 = {
      description = "Core Landing Zone ZPR policy for ${var.service_label}-${coalesce(var.tt_vcn3_name, "tt-vcn-3")}-zpr-policy."
      name        = "${var.service_label}-${coalesce(var.tt_vcn3_name, "tt-vcn-3")}-zpr-policy"
      statements  = concat(local.tt_3_hub_zpr_grants, local.tt_3_zpr_grants, local.tt_3_to_tt_1_zpr_grants, local.tt_3_to_tt_2_zpr_grants, local.tt_3_to_exa_1_zpr_grants, local.tt_3_to_exa_2_zpr_grants, local.tt_3_to_exa_3_zpr_grants)
    }
  } : {}
}
