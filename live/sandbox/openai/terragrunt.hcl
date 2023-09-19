terraform {
    # replace with tagged version at some point
    source = "../../../modules//openai"
}

inputs = {
    tm_provider = "azurerm.dev"

    project_name = "OpenAI"
    project_name_lowercase = "openai"
    project_name_short_lowercase = "oai"
    name_prefix = "ScSc-CIO-ECT" #atm cannot recreated the group name so we override it with a hyphen instead of underscore
}

 include "root" {
   path   = find_in_parent_folders()
   expose = true
 }
 