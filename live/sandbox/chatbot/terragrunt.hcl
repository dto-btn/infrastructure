terraform {
    source = "git::git@github.com:dto-btn/chatbot-infra.git//chatbot?ref=v1.0.3"
}

inputs = {
    tm_provider = "azurerm.sandbox" # this one needs to stay here because there are multiple prov per subs lvls

    project_name = "OpenAI-Chatbot-Sandbox"
    project_name_lowercase = "openaichatbotsandbox"
    project_name_short_lowercase = "oaichatsb"

    # the python api version (one that talks to Azure OpenAI)
    api_version = "3.0.6"
    api_version_sha = "4b3e6bd2d272f8a90c67e1a99ae647e2f3fb6572"

    frontend_branch_name = "preview"

    enable_auth = false

    env = "Sandbox"
    name_prefix = "ScSc-CIO"
    name_prefix_lowercase = "scsccio"

    openai_endpoint_name = "scsc-cio-ect-openai-oai"
    openai_key_name = "scsc-cio-ect-openai-oai"
    openai_deployment_name = "gpt-4" # or gpt-35-turbo-16k
}

locals {
    config = read_terragrunt_config(find_in_parent_folders("local.hcl")).locals
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
            ARM_SUBSCRIPTION_ID     = local.config.sandbox.subscription_id
        }

        required_var_files = [ "${get_repo_root()}/secret.tfvars" ]
    }
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