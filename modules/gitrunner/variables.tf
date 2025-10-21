################################################################################
##################### Existing resources #######################################
################################################################################
variable "resource_group" {
    type    = string
}

variable "location" {
    type = string
}

variable "key_vault" {
    description = "Existing KeyVault to create secrets"
    type = object({
      name = string
      id = string
      resource_group_name = string
      resource_group_id = string
    })
}

variable "log_analytics_workspace" {
    description = "Existing log analytics workspace to log logs"
    type = object({
      name = string
      resource_group_name = string
    })
}

################################################################################
############### Container App Environment values ###############################
################################################################################

variable "use_existing_cae" {
    description = "Whether you want to re-use existing container app environment or not.  cae_name will be used for new and to search for existing"
    type = bool
}

variable "cae_name" {
    description = "New or existing cae name"
    type = string
}

variable "cae_job_name" {
    description = "Container App Environment Job name"
    type = string
}

variable "cae_job_secrets" {
    description = "Additional secrets needed to be added in container app environment"
    type = list(object({
        name = string
        value = string
    }))
    default = []
}

################################################################################
# Azure Container Registry #####################################################
################################################################################

variable "acr" {
    description = "Existing ACR data"
    type = object({
      name = string
      resource_group_name = string
    })
}

variable "acr_image_repo_name" {
    description = "Name of repository to be created in the ACR"
    type = string
}

variable "acr_image_repo_tag" {
    description = "Tag for the created repository"
    type = string
    default = null
}

################################################################################
############# Custom Action Runner Image Repo ##################################
################################################################################

variable "github-action-runner-image" {
    description = "Values for repo holding dockerfile for building the action runner image. Repo used to build image to be placed in ACR repository (acr_image_repo_name)"
    type = object({
        dockerFile_path = string
        context_path = string
        context_access_token = string
    })
}

variable "acr_image_env_var" {
    description = "Env variables needed for built git runner image"
    type = list(object({
        name = string
        value = optional(string)
        secretRef = optional(string)
    }))
}
# example 
# "env": [
#     {
#         "name": "GITHUB_PAT",
#         "secretRef": "personal-access-token"
#     },
#     {
#         "name": "GH_URL",
#         "value": "https://github.com/dto-btn/tfrunnertest"
#     },
#     {
#         "name": "REGISTRATION_TOKEN_API_URL",
#         "value": "https://api.github.com/repos/dto-btn/tfrunnertest/actions/runners/registration-token"
#     }
# ]

################################################################################
################# Target Github (to poll from) #################################
################################################################################
variable "github_owner" {
    description = "owner of the github account/org"
    type = string
}

variable "runner_scope" {
    description = "scope of where the git runner will poll from"
    type = string
    default = "org"
}

#this will be array, to lower api rate limit.  org scans all repos, calls individually per repo
variable "github_repo_names" {
    type = string
    default = null
    description = "List of repos to poll from and scale."
}

################################################################################
############# Target Github's GitHub App Values ################################
################################################################################

#For KEDA scale meta data property. 
variable "GITHUB_APP_ID" {
    description = "App ID from the created GitHub App on the account"
    type = string
}

#For KEDA scale meta data property. 
variable "GITHUB_APP_INSTALLATION_ID" {
    description = "Installation Id for the created GitHub App on the account. Value is typically found in URL"
    type = string
}

variable "github-app-pem-file-path" {
    type = string
    description = "Filepath of where the PEM file is located on whichever machine terragrunt runs from"
}

################################################################################
######### Managed user identity for certain activities #########################
################################################################################

variable "user_assigned_identity_name" {
    type = string
    description = "used to pull acr image and potentially keyvault access.  Will need ACRPULL role on the scope of the ACR it's pulling from"
}





