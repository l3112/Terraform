


#this is the network security group
resource "azurerm_network_security_group" "CA" {
    name                = "CA"
    location            = "eastus"
    resource_group_name = var.resourceGroupName
  
}
output "id" {
    value = azurerm_network_security_group.CA.id
  }

  output "SecurityRule" {
    value = azurerm_network_security_group.CA.security_rule
  }






