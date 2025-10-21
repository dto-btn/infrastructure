terraform {
    source = "../../../modules//gitrunner"
}

dependency "kvacr" {
    config_path = "../global"
}

inputs = {
    resource_group = "ScSc-CIO_ECT_RunnerTest-rg"
    location = "canadacentral"
    use_existing_cae = false
    cae_job_name = "gc-github-runner-job"
    cae_name = "dto-btn"
    acr = {
        name = dependency.kvacr.outputs.acr_name
        resource_group_name = dependency.kvacr.outputs.resource_group_name
    }
    user_assigned_identity_name = "action-runner-identity"
    github_repo_names = "tfrunnertest"
    github_owner = "dto-btn"
    runner_scope = "org"
    key_vault = {
        name = dependency.kvacr.outputs.key_vault_name
        resource_group_name = dependency.kvacr.outputs.resource_group_name
        resource_group_id = dependency.kvacr.outputs.resource_group_id
        id = dependency.kvacr.outputs.key_vault_id
    }
    acr_image_repo_name = "githubrunnerimage"
    acr_image_repo_tag = "latest"
    log_analytics_workspace = {
        name = dependency.kvacr.outputs.log_analytics_workspace_name
        resource_group_name = dependency.kvacr.outputs.resource_group_name
    }
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
            "name":"PEM",
            "secretRef": "pem"
        },
        {
            "name": "GH_URL",
            "value": "https://github.com/dto-btn"
        },
        {
            "name": "REGISTRATION_TOKEN_API_URL",
            "value": "https://api.github.com/orgs/dto-btn/actions/runners/registration-token"
        }
    ],
    GITHUB_APP_ID = "2013936"
    GITHUB_APP_INSTALLATION_ID = "87587800"
    github-action-runner-image = {
        dockerFile_path = "Dockerfile"
        context_path = "https://github.com/dto-btn/git-action-runner"
        context_access_token = "NA"
    }
    github-app-pem-file-path = "C:/odt/gitrunnertestdto-private-key.pem"
    subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
}

include "root" {
   path   = find_in_parent_folders("root.hcl")
   expose = true
}