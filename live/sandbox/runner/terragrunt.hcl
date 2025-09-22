terraform {
    source = "../../../modules//gitrunner"
}

inputs = {
    resource_group = ""
    location = ""
    cae_name = ""
    cae_job_name = ""
    acr_name = ""
    user_assigned_identity_name = ""
    github_repo_name = ""
    github_repo_owner = ""
    runner_scope = ""
    acr_repo_name = ""
    acr_image_env_var = [
        {
            "name": "GITHUB_PAT",
            "secretRef": "personal-access-token"
        },
        {
            "name": "GH_URL",
            "value": "https://github.com/dto-btn/tfrunnertest"
        },
        {
            "name": "REGISTRATION_TOKEN_API_URL",
            "value": "https://api.github.com/repos/dto-btn/tfrunnertest/actions/runners/registration-token"
        }
    ]
}

include "root" {
   path   = find_in_parent_folders()
   expose = true
}