terraform {
    source = "git::git@github.com:dto-btn/chatbot-infra.git//chatbot?ref=v1.0.1"
}

inputs = {
    tm_provider = "azurerm.sandbox" # this one needs to stay here because there are multiple prov per subs lvls

    project_name = "OpenAI-Chatbot-Sandbox"
    project_name_lowercase = "openaichatbotsandbox"
    project_name_short_lowercase = "oaichatsb"

    # the python api version (one that talks to Azure OpenAI)
    api_version = "3.0.5"
    api_version_sha = "1c88ac7d4d3d40ddf46451de4c22d9af2d20dff2"

    enable_auth = false
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}