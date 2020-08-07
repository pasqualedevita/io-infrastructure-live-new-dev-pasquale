# Internal
dependency "resource_group" {
  config_path = "../../../../resource_group"
}

# Internal
dependency "function_app" {
  config_path = "../../function_app/function"
}

# Internal
dependency "subnet" {
  config_path = "../subnet"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_private_endpoint?ref=v2.0.34"
}

inputs = {
  name                = "${dependency.function_app.outputs.storage_account.name}-file-endpoint"
  resource_group_name = dependency.resource_group.outputs.resource_name
  subnet_id           = dependency.subnet.outputs.id

  private_service_connection = {
    name                           = "${dependency.function_app.outputs.storage_account.name}-file"
    private_connection_resource_id = dependency.function_app.outputs.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }
}