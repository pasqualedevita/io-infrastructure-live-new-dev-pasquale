# Internal
dependency "resource_group" {
  config_path = "../../../../resource_group"
}

dependency "subnet" {
  config_path = "../subnet"
}

dependency "application_insights" {
  config_path = "../../../../application_insights"
}

dependency "storage_account_pdvprivate" {
  config_path = "../../../storage_pdvprivate/storage_account"
}

dependency "storage_functions_content" {
  config_path = "../../../storage_functions_content/storage_account"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  # source = "git::git@github.com:pagopa/io-infrastructure-modules-new.git//azurerm_function_app?ref=v2.0.34"
  source = "git::git@github.com:pasqualedevita/io-infrastructure-modules-new-dev-pasquale.git//master_azurerm_function_app?ref=master"
}

inputs = {
  name                = "pdvprivate"
  resource_group_name = dependency.resource_group.outputs.resource_name

  resources_prefix = {
    function_app     = "fn3"
    app_service_plan = "fn3"
    storage_account  = "fn3"
  }

  //   app_service_plan_info = {
  //     kind     = "App"
  //     sku_tier = "Free"
  //     sku_size = "F1"
  //  }

  app_service_plan_info = {
    kind     = "elastic"
    sku_tier = "ElasticPremium"
    sku_size = "EP1"
  }

  runtime_version                          = "~3"
  pre_warmed_instance_count                = 0
  application_insights_instrumentation_key = dependency.application_insights.outputs.instrumentation_key

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "10.14.1"
    WEBSITE_RUN_FROM_PACKAGE     = "1"
    WEBSITE_VNET_ROUTE_ALL       = "1"
    WEBSITE_DNS_SERVER           = "168.63.129.16"
    // https://docs.microsoft.com/en-us/samples/azure-samples/azure-functions-private-endpoints/connect-to-private-endpoints-with-azure-functions/
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = dependency.storage_functions_content.outputs.primary_connection_string
    PdvPrivateStorageConnection              = dependency.storage_account_pdvprivate.outputs.primary_connection_string
  }

  app_settings_secrets = {
    key_vault_id = "dummy"
    map          = {}
  }

  subnet_id = dependency.subnet.outputs.id
}
