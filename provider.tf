provider "azurerm" {
  version         = "2.0.0" #the latest. 2.0.0 is the old one
  subscription_id = var.subscriptionID

  features {}
}