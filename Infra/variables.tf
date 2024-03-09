variable "tenant_id" {
  type    = string
  default = "${sys.env.ARM_TENANT_ID}"
}
