variable "default_subnet" {
  type        = string
  description = "The ID of the default subnet for the resource."
  default     = "10.10.1.0/24"
}

variable "default_ssh_key" {
  description = "Default SSH key if Key Vault is not provisioned or secret is not found"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."
}

variable "enable_ssh_key" {
  description = "A flag to enable SSH key retrieval from Key Vault"
  type        = bool
  default     = false
}
