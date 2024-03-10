resource "random_string" "example" {
  length  = 8
  special = false
  upper   = false
  numeric  = true
}
