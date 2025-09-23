terraform {
    source = "../../../modules//gitrunner"
}

dependency "kvacr" {
    config_path = "../infrastructure"
}

inputs = {
    resource_group = "ScSc-CIO_ECT_RunnerTest-rg"
    location = "canadacentral"
    cae_name = "cae-action-runner"
    cae_job_name = "cae-action-runner-job"
    # acr_name = "dtocontainer"
    acr_name = dependency.kvacr.outputs.acr_name
    user_assigned_identity_name = "action-runner-identity"
    github_repo_name = "tfrunnertest"
    github_repo_owner = "dto-btn"
    runner_scope = "repo"
    key_vault_name = dependency.kvacr.outputs.key_vault_name


    # these to be taken out.  repo name wont be defined until an image is built. image env var will change if we do github app 
    # acr_repo_name = ""
    # acr_image_env_var = [
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
}

include "root" {
   path   = find_in_parent_folders("root.hcl")
   expose = true
}