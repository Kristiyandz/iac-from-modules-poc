locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  common_tags = read_terragrunt_config(find_in_parent_folders("common_tags.hcl"))

  account = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  region = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  aws_account_id = local.account.locals.aws_account_id

  aws_region = local.region.locals.aws_region

  env = local.environment_vars.locals.environment

  env_tags = {
    Component   = "Test App"
    Environment = local.environment_vars.locals.environment
    Account     = local.account.locals.aws_account_id
  }
}

terraform {
  source = "git::https://github.com/Kristiyandz/vpc-module.git//vpc?ref=v1.1.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws_region  = local.region.locals.aws_region
  environment = local.environment_vars.locals.environment
  tags        = merge(local.common_tags.locals.default_tags, local.env_tags)
  vpc_cidr    = "10.0.0.0/16"
  application = "kirs-test-vpc-module-app"
}

