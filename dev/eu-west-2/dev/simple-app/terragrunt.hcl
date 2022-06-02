locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  common_tags = read_terragrunt_config(find_in_parent_folders("common_tags.hcl"))

  account = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  aws_account_id = local.account.locals.aws_account_id

  aws_region = local.region.locals.aws_region

  env = local.environment_vars.locals.environment

  env_tags = {
    Component   = "Test App"
    Environment = local.environment.locals.environment
    Account     = local.account.locals.aws_account_id
  }
}

terraform {
  source = "${path_relative_from_include()}/modules//simple-app"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws_s3_bucket = "tf-example-kris@"
}

