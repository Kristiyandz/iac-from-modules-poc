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
  source = "git::https://github.com/Kristiyandz/vpc-module.git//vpc"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws_region     = local.region.locals.aws_region
  environment    = local.environment_vars.locals.environment
  tags           = merge(local.common_tags.locals.default_tags, local.env_tags)
  vpc_cidr       = "10.27.0.0/18"
  azs            = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  public_subnets = ["10.27.0.0/27", "10.27.0.32/27", "10.27.0.64/27"]
  application    = "kirs-test-vpc-module-app"
}

