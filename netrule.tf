#this is a network rule. not a VM rule If you want to use SSH
# Commented out by default

/* resource "azurerm_network_security_rule" "Allow22" {
  name                      = "Allow22"
  priority                  = 101
  direction                 = "Inbound"
  access                    = "Allow"
  protocol                  = "TCP"
  source_port_range         = "*" #who and what we want to be able to access
  destination_port_range    = "22" #what port we want open
  source_address_prefix     = "*" #You can put 73.71.218.187 (For testing, I leave it to any)
  destination_address_prefix = "*" # CIDR
  resource_group_name         = azurerm_network_security_group.CA.resource_group_name #who and what we want to be able to access
  network_security_group_name = azurerm_network_security_group.CA.name
}
 */
#25 and 26 are interpolating variables we've already established

# This one is mandatory


  #puts the rules on the network interface

  resource "azurerm_network_interface_security_group_association" "RuleAttach" {
  network_interface_id      = azurerm_network_interface.CA-NetInt.id
  network_security_group_id = azurerm_network_security_group.CA.id
}
