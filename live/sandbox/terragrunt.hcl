locals {
    config = read_terragrunt_config(find_in_parent_folders("local.hcl")).locals
}

generate "terraform" {
  path      = "terraform.tf"
  if_exists = "overwrite"
  contents  = file("../common/terraform.tf")
}

# the two providers here are needed since we have a data block in a different env (ScDC), this is temporary.
generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite"
    contents = <<EOF
provider "azurerm" {
  subscription_id = "${local.config.sandbox-ect.subscription_id}"
  tenant_id       = "${local.config.sandbox-ect.tenant_id}"
  client_id       = "${local.config.sandbox-ect.client_id}"
  client_secret   = "${local.config.sandbox-ect.client_secret}"

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
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
            "untaint",
            "destroy"
        ]

        env_vars = {
            ARM_SUBSCRIPTION_ID     = local.config.sandbox-ect.subscription_id
        }
        #required_var_files = [ "${get_repo_root()}/secret.tfvars" ]
    }
}

remote_state {
    backend = "azurerm"
    config = {
        key = "${path_relative_to_include()}/terraform.tfstate"
        resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
        storage_account_name = "ectinfra"
        container_name = "tfstate"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}

inputs = {
    env = "Sandbox"
    name_prefix = "ScSc-CIO_ECT"
    name_prefix_lowercase = "scsccioect"
}