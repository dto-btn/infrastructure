terraform {
    source = "../../../modules//gitrunner"
}

dependency "kvacr" {
    config_path = "../global"
}

inputs = {
    resource_group = "G3Pc-SSC_CIOAssistant_Project-rg"
    location = "canadacentral"

    #cae
    use_existing_cae = false
    cae_job_name = "ent-github-runner-job"
    cae_name = "dto-btn"

    #acr
    acr = {
        name = "dtoent"
        resource_group_name = "G3Pc-SSC_CIOAssistant_Project-rg"
    }
    acr_image_repo_name = "githubrunnerimage"
    acr_image_repo_tag = "latest"

    #location of runner image
    github-action-runner-image = {
        dockerFile_path = "Dockerfile"
        context_path = "https://github.com/dto-btn/git-action-runner"
        context_access_token = "NA"
    }

    #container env var
    acr_image_env_var = [
        {
            "name": "CLIENT_ID",
            "value": "Iv23lijrPzVx10OnWRaB"
        },
        {
            "name": "INSTALLATION_ID",
            "value": "91290353"
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

    #for KEDA scale meta data property
    GITHUB_APP_ID = "2165312"
    GITHUB_APP_INSTALLATION_ID = "91290353"
    GITHUB_APP_PEM_KEYVAULT_NAME = "githubrunnerpem"

    #target
    github_repo_names = "tfrunnertest"
    github_owner = "dto-btn"
    runner_scope = "org"
    # github-app-pem-file-path = "C:/odt/gitrunnertestdto-private-key.pem"

    user_assigned_identity_name = "action-runner-identity"
    
    key_vault = {
        name = "G3PcCKV-SSC-CIOA-0452-kv"
        resource_group_name = "G3Pc-SSC_CIOAssistant_Keyvault-rg"
        # resource_group_id = dependency.kvacr.outputs.resource_group_id
        # id = dependency.kvacr.outputs.key_vault_id
    }

    log_analytics_workspace = {
        name = "G3PcCLD-SSC-CIOAssistant-3a7e5ed3-law"
        resource_group_name = "G3Pc-SSC_CIOAssistant_Logs-rg"
    }
    
    subscription_id = "dd7b6f23-7cf4-4598-a0ba-55888cfb1616"
}

include "root" {
   path   = find_in_parent_folders("root.hcl")
   expose = true
}