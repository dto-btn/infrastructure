# variable "subscription_id" {
#   type = string
# }
variable "resource_group" {
  type = string
}

variable "create_resource_group" {
  type = bool
  default = true
}

variable "create_container_app_env" {
  type = bool
  default = true
}

variable "location" {
  type = string
}

variable "acr" {
  type = object({
    name = string
    resource_group_name = string
    image = object({
      repo_name = string
      tag = string
    })
  })
  description = "Existing container registry and repo values"
}

variable "log_analytics" {
  type = object({
    name = string
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
  })
}

variable "app_registration_name" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "env_vars" {
  type        = map(string)
  description = "A map of environment variables to pass to the container app"
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