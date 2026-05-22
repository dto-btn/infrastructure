variable "container_apps" {
  type = map(object({
    config                   = map(any)
    create_resource_group    = bool
    create_container_app_env = bool
    env_vars                 = map(any)
    acr_image                = map(string)
    secrets                  = map(string)
  }))
}