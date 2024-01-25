terraform {
    # replace with tagged version at some point
    source = "git::git@github.com:dto-btn/sscplus-data-fetch.git//terraform?ref=main"
}

inputs = {
    project_name = "SSCPlusData"
    project_name_short = "SSCPlusData"
    openai_name = "ScSc-CIO-ECT-OpenAI-oai"
    openai_rg = "ScSc-CIO-ECT-OpenAI-rg"
    # fileshare_name and fileshare_connection_string should be located inside the secret.tfvars file
}

 include "root" {
   path   = find_in_parent_folders()
   expose = true
 }