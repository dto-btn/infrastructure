terraform {
    source = "git::git@github.com:dto-btn/chatbot-infra.git//chatbot?ref=v1.0.7"

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
            ARM_SUBSCRIPTION_ID     = local.config.dev.subscription_id
        }

        required_var_files = [ "${get_repo_root()}/secret.tfvars" ]
    }
}

inputs = {
    tm_provider = "azurerm.dev"

    project_name = "OpenAI-Chatbot-Pilot"
    project_name_lowercase = "openaichatbotpilot"
    project_name_short_lowercase = "oaichat"

    # the python api version (one that talks to Azure OpenAI)
    api_version = "3.1.3"
    api_version_sha = "25839c7eada66ab9b95ca9bba081c6a1d7e32d30"

    env = "Pilot" # override of Dev
    enable_auth = true

    name_prefix = "ScDc-CIO"
    name_prefix_lowercase = "scdccio"

    #openai_endpoint_name = "scdc-cio-dto-openai-poc-oai"
    #openai_key_name = "AzureOpenAIKey"
    openai_endpoint_name = "scsc-cio-ect-openai-oai"
    openai_key_name = "scsc-cio-ect-openai-oai"

    index_name = "latest"
}

locals {
    config = read_terragrunt_config(find_in_parent_folders("local-secrets.hcl")).locals
}

generate "terraform" {
  path      = "terraform.tf"
  if_exists = "overwrite"
  contents  = file("../../common/terraform.tf")
}

# this is temporary and needed since the base modules contain reference to a provider, this should be removed in future releases
generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite"
    contents = <<EOF
provider "azurerm" {
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
        resource_group_name = "ScDc-CIO-DTO-Infrastructure-rg"
        storage_account_name = "scdcinfrastructure"
        container_name = "tfstate"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}