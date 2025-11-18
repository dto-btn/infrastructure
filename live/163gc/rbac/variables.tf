variable "subscription_id" {
    type = string
}

variable "permissions" {
  description = "just ideas for now.  Principle type to handle groups and individual users?"
  type = list(object({
    scope_id = string # role def needs to have this assignable scope
    name = string
    principal_type = string
    principal_name = string
    role_definitions = string #should this be list?
  }))
}
