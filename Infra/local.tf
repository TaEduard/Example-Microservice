resource "random_string" "example" {
  length  = 4
  special = false
  upper   = false
  numeric  = true
}
