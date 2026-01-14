variable "resource_group_name" {
  type        = string
  default = "knowledge-hub-rg"
  description = "Existing resource group where the storage account will live."
}

variable "storage_account_name" {
  type        = string
  default = "kbhubsa"
  description = "Globally unique, lowercase storage account name (3-24 chars)."
}

variable "public_container_name" {
  type        = string
  default     = "dropzone"
  description = "Container that allows anonymous blob reads."
}

variable "private_container_name" {
  type        = string
  default     = "backups"
  description = "Container restricted to explicit role assignments."
}

variable "private_container_emails" {
  type        = list(string)
  default     = ["Muhammed.Imran@ssc-spc.gc.ca"]
  description = "List of user principal names to grant Storage Blob Data Contributor on the private container."
}
