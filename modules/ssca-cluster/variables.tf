# variable "subscription_id" {
#   type = string
# }

variable "resource_group" {
  type = string
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
    name = string
    revision_mode = string
  })
}

variable "app_registation_name" {
  type = string
}