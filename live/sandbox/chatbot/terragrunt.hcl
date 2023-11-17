terraform {
    source = "git::git@github.com:dto-btn/chatbot-infra.git//chatbot?ref=v1.0.6"

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
            ARM_SUBSCRIPTION_ID     = local.config.sandbox.subscription_id
        }

        required_var_files = [ "${get_repo_root()}/secret.tfvars" ]
    }
}

inputs = {
    tm_provider = "azurerm.sandbox" # this one needs to stay here because there are multiple prov per subs lvls

    project_name = "OpenAI-Chatbot-Sandbox"
    project_name_lowercase = "openaichatbotsandbox"
    project_name_short_lowercase = "oaichatsb"

    # the python api version (one that talks to Azure OpenAI)
    api_version = "3.1.1"
    api_version_sha = "ea59aa1468524dfa936a7dc013774230b6c0f2f7"

    frontend_branch_name = "preview"

    enable_auth = false

    env = "Sandbox"
    name_prefix = "ScSc-CIO"
    name_prefix_lowercase = "scsccio"

    openai_endpoint_name = "scsc-cio-ect-openai-oai"
    openai_key_name = "scsc-cio-ect-openai-oai"

    index_name = "2023-11-01"
}

locals {
    config = read_terragrunt_config(find_in_parent_folders("local-secrets.hcl")).locals
}

generate "terraform" {
  path      = "terraform.tf"
  if_exists = "overwrite"
  contents  = file("../../common/terraform.tf")
}

# the two providers here are needed since we have a data block in a different env (ScDC), this is temporary.
generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite"
    contents = <<EOF
provider "azurerm" {
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
EOF
}

remote_state {
    backend = "azurerm"
    config = {
        key = "${path_relative_to_include()}/terraform.tfstate"
        resource_group_name = "ScSc-CIO-DTO-Infrastructure-rg"
        storage_account_name = "scscinfrastructure"
        container_name = "tfstate"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}