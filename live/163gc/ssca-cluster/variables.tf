variable "ssca_mcp_env_vars" {
  type    = map(string)
  default = {}
}

variable "ssca_mcp_secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "geds_mcp_env_vars" {
  type    = map(string)
  default = {}
}

variable "geds_mcp_secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "pmcoe_mcp_env_vars" {
  type    = map(string)
  default = {}
}

variable "pmcoe_mcp_secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "myssc_mcp_env_vars" {
  type    = map(string)
  default = {}
}

variable "myssc_mcp_secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "bits_mcp_env_vars" {
  type    = map(string)
  default = {}
}

variable "bits_mcp_secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "litellm_proxy_env_vars" {
  type    = map(string)
  default = {}
}

variable "litellm_proxy_secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}
