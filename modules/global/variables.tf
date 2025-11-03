variable "resource_group_name" {
    type = string
}

variable "name_prefix" {
    type = string
}

variable "acr_name" {
    type = string
}

variable "tenant_id" {
    type = string
}

#used to apply default access policies
# variable "key_vault_access_policies" {
#     type = object({
#         object_id = string
#         permissions = string
#     })
# }