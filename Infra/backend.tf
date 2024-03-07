terraform {
  backend "azurerm" {
    resource_group_name   = "TFState"
    storage_account_name  = "mystorerraform"
    container_name        = "terraformstate"
    key                   = "prod.terraform.tfstate"
  }
}
