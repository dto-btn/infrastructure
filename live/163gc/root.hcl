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

inputs = {
    # env = "Sandbox"
    # name_prefix = "ScSc-CIO_ECT"
}