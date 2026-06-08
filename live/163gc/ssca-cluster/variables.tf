variable "container_apps" {
  type = map(object({
    container_app = object({
      name          = string
      revision_mode = string
      min_replicas  = optional(number, 0)
      target_port   = optional(number, 8000)
    })
    create_resource_group    = optional(bool, false)
    create_container_app_env = optional(bool, false)
    env_vars                 = optional(map(string), {})
    acr_image = object({
      repo_name = string
      tag       = string
    })
    secrets                = optional(map(string), {})
    allowed_origins        = optional(list(string), null)
    unauthenticated_access = optional(bool, false)
  }))
}