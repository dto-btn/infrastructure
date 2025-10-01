variable "resource_group" {
    type    = string
}

variable "location" {
    type = string
}

variable "runner_name" {
    type = string
}

variable "use_existing_cae" {
    type = bool
}

variable "cae_name" {
    type = string
}

variable "cae_job_name" {
    type = string
}

variable "acr" {
    type = object({
      name = string
      resource_group_name = string
    })
}

variable "user_assigned_identity_name" {
    type = string
}

# variable "github_repo_name" {
#     type = string
# }

variable "github_repo_owner" {
    type = string
}

variable "runner_scope" {
    type = string
    default = "org"
}

variable "acr_image_repo_name" {
    type = string
}

variable "cae_job_secrets" {
    type = list(object({
        name = string
        value = string
    }))
}

variable "key_vault" {
    type = object({
      name = string
      resource_group_name = string
    })
}

variable "log_analytics_workspace" {
    type = object({
      name = string
      resource_group_name = string
    })
}

variable "acr_image_env_var" {
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

variable "GITHUB_APP_ID" {
    type = string
}
variable "GITHUB_APP_INSTALLATION_ID" {
    type = string
}