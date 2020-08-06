dependency "storage_account" {
  config_path = "../storage_account"
}

dependency "private_endpoint" {
  config_path = "../private_endpoint_blob"
}

dependency "resource_group" {
  config_path = "../../../resource_group"
}

dependency "private_dns_zone" {
  config_path = "../../private_dns_zones/privatelink-blob-core-windows-net/zone"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_private_dns_a_record?ref=v2.0.34"
}

inputs = {
  resource_group_name = dependency.resource_group.outputs.resource_name
  zone_name           = dependency.private_dns_zone.outputs.name[0]
  name                = dependency.storage_account.outputs.resource_name
  ttl                 = 3600
  records             = dependency.private_endpoint.outputs.private_ip_address
}