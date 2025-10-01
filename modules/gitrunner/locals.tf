locals {
    scale_rule_metadata = merge(
        {
            "githubAPIURL": "https://api.github.com",
            "owner": "${var.github_owner}",
            "runnerScope": "${var.runner_scope}",
            "targetWorkflowQueueLength": "1",
            "applicationID": "${var.GITHUB_APP_ID}",
            "installationID": "${var.GITHUB_APP_INSTALLATION_ID}",
        },
        var.github_repo_names != null ? {
            "repos": "${var.github_repo_names}",
        } : {}
    )
}