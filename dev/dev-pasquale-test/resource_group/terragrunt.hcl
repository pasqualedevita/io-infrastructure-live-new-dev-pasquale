# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:pasqualedevita/io-infrastructure-modules-new-dev-pasquale.git//azurerm_resource_group?ref=master"
}

inputs = {
  fullname = "dev-pasquale-test"
}
