terraform {
    source = "git::git@github.com:dto-btn/chatbot-infra.git//chatbot?ref=v1.0.1"
}

inputs = {
    tm_provider = "azurerm.dev"

    project_name = "OpenAI-Chatbot-Pilot"
    project_name_lowercase = "openaichatbotpilot"
    project_name_short_lowercase = "oaichat"

    # the python api version (one that talks to Azure OpenAI)
    api_version = "3.0.5"
    api_version_sha = "1c88ac7d4d3d40ddf46451de4c22d9af2d20dff2"

    env = "Pilot" # override of Dev
    enable_auth = true
}

 include "root" {
   path   = find_in_parent_folders()
   expose = true
 }