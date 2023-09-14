# infrastructure
General infrastructure of DTO team.

This is split by environements, and we currently only have environements in Azure, 
so we use their zoning to group project/modules togheter.

The 3 main environements at SSC inside Azure: 

* Sandbox (`ScSc`),
* Dev (`ScDc`),
* Prod (`ScPc`)

So we end up with this structure: 

* `live`
  * `dev`
    * `chatbot`
    * `projectB`
  * `sandbox`
    * `chatbot`
    * `projectC`

And so on ..

## dev

First make sure you have all the [pre-requisites](#pre-requisites).

In order to run a specific subset (for instance, I want to setup chatbot in sandbox):

```bash
cd live/sandbox/chatbot
terragrunt plan --terragrunt-source ~/git/chatbot-infra/chatbot
```

Ignore `--terragrunt-source` if you would rather use the true `source` value from the `terraform` block in the `terragrunt.hcl` (in most case, remote github source)

### pre-requisites

You will need those tools:

* terraform
* terragrunt
* az client

And make sure you have created a `secret.tfvars` at the root folder and populate it with the following..
But all variables below can also be defined in the environments with prefix `TF_VAR_` instead (ex: `TF_VAR_dev_sub_id`).

```
personal_token="<github-secret-to-pull>"
microsoft_provider_authentication_secret="<secret>"
```

You also need to create at the root a `config.hcl` file and populate the following content: 

(subscription ids are considered non sensitive but in this case we are taking an extra precaution)

```hcl
locals {
    dev = {
        subscription_id = "<sub_id>"
        tenant_id = "<secret>"
        client_id = "<secret>"
        client_secret = "<secret>"
    }

    sandbox = {
        ...
    }
}
```

**NOTE**: Messing things up above could yeild pretty bad consequences...