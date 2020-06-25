# Internal
dependency "resource_group" {
  config_path = "../../../resource_group"
}

dependency "application_insights" {
  config_path = "../../../application_insights"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pasqualedevita/io-infrastructure-modules-new-dev-pasquale.git//azurerm_function_app?ref=master"
}

inputs = {
  name                = "dfmonitor"
  resource_group_name = dependency.resource_group.outputs.resource_name

  resources_prefix = {
    function_app = "fn3"
    app_service_plan = "fn3"
    storage_account = "fn3"
  }

  app_service_plan_info = {
    kind     = "App"
    sku_tier = "Free"
    sku_size = "F1"
 }

  // app_service_plan_info = {
  //  kind     = "elastic"
  //  sku_tier = "ElasticPremium"
  //  sku_size = "EP3"
  // }

  runtime_version                          = "~3"
  pre_warmed_instance_count                = 0
  application_insights_instrumentation_key = dependency.application_insights.outputs.instrumentation_key

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "10.14.1"
  }

}
