output "app_compartment" {
  description = "The compartments in a single flat map."
  value       = module.lz_compartments[0].compartments["APP_CMP"].id
}
