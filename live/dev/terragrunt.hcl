locals {
    config = read_terragrunt_config(find_in_parent_folders("local.hcl")).locals
}

generate "terraform" {
  path      = "terraform.tf"
  if_exists = "overwrite"
  contents  = file("../common/terraform.tf")
}

generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite"
    contents = <<EOF
provider "azurerm" {
  alias = "sandbox"
  subscription_id = "${local.config.sandbox.subscription_id}"
  tenant_id       = "${local.config.sandbox.tenant_id}"
  client_id       = "${local.config.sandbox.client_id}"
  client_secret   = "${local.config.sandbox.client_secret}"

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias = "dev"
  subscription_id = "${local.config.dev.subscription_id}"
  tenant_id       = "${local.config.dev.tenant_id}"
  client_id       = "${local.config.dev.client_id}"
  client_secret   = "${local.config.dev.client_secret}"

  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

provider "azurerm" {
  features {}
}
EOF
}

terraform {
    extra_arguments "set-subscription-and-secrets" {
        commands = [
            "init",
            "apply",
            "refresh",
            "import",
            "plan",
            "taint",
            "untaint"
        ]

        env_vars = {
            ARM_SUBSCRIPTION_ID     = local.config.dev.subscription_id
        }

        required_var_files = [ "${get_repo_root()}/secret.tfvars" ]
    }
}

remote_state {
    backend = "azurerm"
    config = {
        subscription = var.dev_sub_id
        key = "${path_relative_to_include()}/terraform.tfstate"
        resource_group_name = "ScDc-CIO-DTO-Infrastructure-rg"
        storage_account_name = "scdcinfrastructure"
        container_name = "tfstate"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}

inputs = {
    env = "Dev"
    name_prefix = "ScDc-CIO"
    name_prefix_lowercase = "scdccio"
}