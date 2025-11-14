variable "permissions" {
  description = "just ideas for now.  Principle type to handle groups and individual users?"
  type = list(object({
    scope = string
    role_def = string
    principle_type = string
    principle_name = string
  }))
}