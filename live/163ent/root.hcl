locals {
    # config = read_terragrunt_config(find_in_parent_folders("local-secrets.hcl")).locals
}

generate "terraform" {
  path      = "terraform.tf"
  if_exists = "overwrite"
  contents  = file("../common/terraform.tf")
}

generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite"
    contents  = file("../common/provider.tf")
    # contents = <<EOF
    #             provider "azurerm" {
    #                 resource_provider_registrations = "none"
    #                 features {
    #                     resource_group {
    #                         prevent_deletion_if_contains_resources = false
    #                     }
    #                 }
    #             }
    #         EOF
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

        # env_vars = {
        #     ARM_SUBSCRIPTION_ID     = local.config.sandbox-ect.subscription_id
        # }
        # required_var_files = [ "${get_repo_root()}/secret.tfvars" ]
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
    # env = "Sandbox"
    # name_prefix = "ScSc-CIO_ECT"
}