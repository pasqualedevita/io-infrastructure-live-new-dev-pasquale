# Internal
dependency "resource_group" {
  config_path = "../resource_group"
}

# Common
dependency "application_insights" {
  config_path = "../application_insights"
}

dependency "storage_account_logs" {
  config_path = "../storage_account"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pasqualedevita/io-infrastructure-modules-new-dev-pasquale.git//azurerm_app_service?ref=master"
}

inputs = {
  name                = "appservice-log"
  resource_group_name = dependency.resource_group.outputs.resource_name

  app_service_plan_info = {
    kind                         = "Windows"
    sku_tier                     = "Free"
    sku_size                     = "F1"
    maximum_elastic_worker_count = 0
  }

  app_enabled         = true
  client_cert_enabled = false
  https_only          = false

  application_insights_instrumentation_key = dependency.application_insights.outputs.instrumentation_key

  app_settings = {
    WEBSITE_NODE_DEFAULT_VERSION = "10.14.2"
    WEBSITE_RUN_FROM_PACKAGE     = "1"
  }

}
