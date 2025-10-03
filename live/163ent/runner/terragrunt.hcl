terraform {
    source = "../../../modules//gitrunner"
}

dependency "kvacr" {
    config_path = "../global"
}

inputs = {
    resource_group = "G3Pc-SSC_CIOAssistant_Project-rg"
    location = "canadacentral"
    use_existing_cae = false
    cae_job_name = "ent-github-runner-job"
    cae_name = "cio-assistant"
    acr = {
        name = dependency.kvacr.outputs.acr_name
        resource_group_name = dependency.kvacr.outputs.resource_group_name
    }
    user_assigned_identity_name = "runnerIdentity"
    github_repo_names = "tfrunnertest"
    github_owner = "dto-btn"
    runner_scope = "org"
    key_vault = {
        name = dependency.kvacr.outputs.key_vault_name
        resource_group_name = dependency.kvacr.outputs.resource_group_name
    }
    acr_image_repo_name = "githubrunnerimage"
    acr_image_repo_tag = "latest"
    cae_job_secrets = [{
        name = "pem"
        #this will be a keyvault reference later
        value = "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEA1P4+rDEPd5dUqKlU4BQKRWQM5HpPlHh7Qqb+YUODUkViKKc1\n5ivpTvS96+bckzONgRpH6wwOUx8aOniQSG64+zB9igOgtdF76g3xzkVNhA4IPxPM\npB9+/6Oo7o0Hj+ivgkgnTifQc2oxpa7zXAp8pwFgmKy/zcSLi7pQoRz0+SHDJnln\nes7GS0b4VuL7DKPYQXIa3DRbqPpNEYGVrIjXRCom4RNwtwXIGJgs9BQAkM94yAr6\nZq/tiQOQ7/e2rnH6f+HGcZF7OGsd18vhLCwU7wx9v2hfX/EsDkjyb1DJWsGmK+vQ\ntIHnPfVizXnSIridwRXV3CkL8YJUlKWKXpZBjwIDAQABAoIBAQCvU3XNkjj0LYrP\np0uphHWL9zaxoIj/Y0m7bPE6qTNhNqH9at7wUDcl+kqX9BqfxTD3E+YdcngcLh8O\nAI5sQVBd3OWKBUB2SjFhUgc4z01mpZJeMfMjKpYE4vg9HbQa3uQSL0jDifyJ9OFX\nTDMhEbTYWEbmhlUAkYh5BW43oTl6FLMaXQMymYP3fFb6g5JtSirTQ61wjwXO7wRo\n27Eoii4CJSFNQIV1xcBuXYxZb68NGu+hJXDODDvqYWkBS4PufDeRgC5NC5NjKJTN\n+9lfmRuo83OHjs9FuMD/SsQAT5hCtgZS3wh0eHjiT84zDwCeBMQWrXBB8BySC24y\nBD5ZcEuRAoGBAO+p+lBI86QODtPUu2KBhN5knbK/6QMWxOZsf2VuHCsIcU+iBVVz\nB/Zf08K+Cx+Jzh7j9dA3RrzYl7wEZSyVqk4sTTZbvH6BoHVJqChjuCJdH/j2d7Rs\neHM8z2CMoJrao11uBpo/wT59500McVtwnyvkjDRSPVFZOuU9YcnjYBVXAoGBAOOC\n36vI1QrvOivjYWoBh7TX71CCsqRenNqPnaXKf2BlQgJY0Zb9r/mI+y7RV4gb7YRB\n6cENpuZHRDJCQ31RQ4SvTPI7uEaEBogCNEIA6odxPx6bYfcIEQRw0l1HFDscvlnb\n4nQ/jWD0D7IsKNL122wCH5hrymA1YB1WmSTCABqJAoGAVh3w2PptuaxnfYx6TLoX\ngUYMOFenJbn/xICGAm9fZcMh3Chu3DZ6TPhAAkEBhDKjQwxMnqXOIDt/wkqeBDg/\nOtnGYNrzz01K1/pAl0rFtmtZ+r6tYsJ7QYU/SwUdDKe1ffP0IWb5TDg3bcMj1GSS\nfVYhXweSCvISLJ8yzTWLp/8CgYAjpE4cIGNXyjCHzaBmNgUnjKieKUuJOpVCHDur\nTHT2Cgb0TSvQhr+5zP7kz8DxvsZP8O+I4fWin8mMQhtGl6OHNttMG5T73xUS252K\nNZCIVXJ4/giz5Zyc4HvkRw1hUVh0xWDNq2MfrDyFQivHGOMeIZsHiuNyfQoorndh\nbc8MWQKBgCNI2KlZIWxhHjkk/blPRs0dhRhxYxauVuVSvjfS29wJ4o2QVrC2BwLi\njh4WAb3ZaXBr121+AsBko8BIDIYG8TDwd03cj0Z1LCP9/0i4XcTmXnMz2dA53deT\nBZ1lg0JgVPU3oaHDUm+1xFenBO+l/Lv46jLpvs4Hgf7nLULlIfAB\n-----END RSA PRIVATE KEY-----\n"
    }]
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
        #this to change to secret ref.  point to keyvault pem file
        {
            "name": "KEY_FILE_NAME",
            "value": "gitrunnertestdto-private-key"
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
    #keyvault reference later
    GITHUB_APP_ID = "2013936"
    GITHUB_APP_INSTALLATION_ID = "87587800"
    github-action-runner-image = {
        dockerFile_path = "Dockerfile"
        context_path = "https://github.com/dto-btn/git-action-runner"
        context_access_token = "NA"
    }
}

include "root" {
   path   = find_in_parent_folders("root.hcl")
   expose = true
}


remote_state {
    backend = "azurerm"
    config = {
        key = "${path_relative_to_include()}/terraform.tfstate"
        resource_group_name = "GcDc-CTO_RPA_Project-rg"
        storage_account_name = "gcdaaconfig"
        container_name = "tfstate"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}

provider "azurerm" {
    resource_provider_registrations = "none"
    subscription_id = "e04326a7-a0a1-4c57-9a29-b8c431d14d35" #this to be placed elsewhere after
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}