terraform {
    source = "../../../modules//gitrunner"
}

dependency "kvacr" {
    config_path = "../global"
}

inputs = {
    resource_group = "ScSc-CIO_ECT_RunnerTest-rg"
    location = "canadacentral"
    runner_name = "dto-btn"
    use_existing_cae = false
    cae_job_name = "github-runner-job"
    cae_name = null
    # acr_name = "dtocontainer"
    acr = {
        name = dependency.kvacr.outputs.acr_name
        resource_group_name = dependency.kvacr.outputs.resource_group_name
    }
    user_assigned_identity_name = "action-runner-identity"
    # github_repo_name = "tfrunnertest"
    github_repo_owner = "dto-btn"
    runner_scope = "org"
    key_vault = {
        name = dependency.kvacr.outputs.key_vault_name
        resource_group_name = dependency.kvacr.outputs.resource_group_name
    }
    acr_image_repo_name = "githubrunnerimage"
    cae_job_secrets = [{
        name = "personal-access-token"
        value = "123"
    }]
    log_analytics_workspace = {
        name = dependency.kvacr.outputs.log_analytics_workspace_name
        resource_group_name = dependency.kvacr.outputs.resource_group_name
    }
    # these will change after we change from pat to github app reg
    acr_image_env_var = [
        {
            "name": "CLIENT_ID",
            "value": "Iv23liUSavN8izwHxrgV"
        },
        {
            "name": "INSTALLATION_ID",
            "value": "87587800"
        },
        {
            "name": "KEY_FILE_NAME",
            "value": "gitrunnertestdto-private-key"
        },
        # {
        #     "name": "KEY_FILE_NAME",
        #     "secretRef": "personal-access-token"
        # },
        {
            "name": "GH_URL",
            "value": "https://github.com/dto-btn"
        },
        {
            "name": "REGISTRATION_TOKEN_API_URL",
            "value": "https://api.github.com/orgs/dto-btn/actions/runners/registration-token"
        }
    ]
}

include "root" {
   path   = find_in_parent_folders("root.hcl")
   expose = true
}