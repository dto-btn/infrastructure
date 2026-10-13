# variable "subscription_id" {
#   type = string
# }
variable "resource_group" {
  type = string
}

variable "create_resource_group" {
  type    = bool
  default = true
}

variable "create_container_app_env" {
  type    = bool
  default = true
}

variable "location" {
  type = string
}

variable "acr" {
  type = object({
    name                = string
    resource_group_name = string
    image = object({
      repo_name = string
      tag       = string
    })
  })
  description = "Existing container registry and repo values"
}

variable "log_analytics" {
  type = object({
    name                = string
    resource_group_name = string
  })
  description = "Existing log analytics workspace values"
}

variable "container_app_environment_name" {
  type = string
}

variable "container_app" {
  type = object({
    name          = string
    revision_mode = string
    min_replicas  = optional(number, 0)
    target_port   = optional(number, 8000)
    startup_probe_initial_delay = optional(number, 0)
  })
}

variable "app_registration_name" {
  description = "App registration to be used with container app's built in authentication (EasyAuth)"
  type = string
}

variable "additional_app_registration_client_ids" {
  type        = list(string)
  description = "Additional app registration client IDs permitted as EasyAuth callers and api:// token audiences"
  default     = []
}

variable "subscription_id" {
  type = string
}

variable "env_vars" {
  type        = map(string)
  description = "A map of environment variables to pass to the container image of the (template->container->env_var) container app"
  default     = {}
}

variable "secrets" {
  type        = map(string)
  description = "A map of secrets to pass to the container app. Key is the env var name, value is the secret value."
  default     = {}
}

variable "allowed_origins" {
  type        = list(string)
  description = "A list of allowed origins for CORS policy"
  default     = ["http://localhost:8080"]
}

variable "unauthenticated_access" {
  type        = bool
  description = "Whether to allow unauthenticated access to the container app"
  default     = false
}

variable "key_vault" {
  type = object({
    name                = string
    resource_group_name = string
  })
  description = "The Key Vault details to fetch secrets from"
  default     = null
}