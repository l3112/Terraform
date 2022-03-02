# For RDP
resource "azurerm_network_security_rule" "Port3389" {
  name                      = "Allow389"
  priority                  = 102
  direction                 = "Inbound"
  access                    = "Allow"
  protocol                  = "TCP"
  source_port_range         = "*" #who and what we want to be able to access
  destination_port_range    = "3389" #what port we want open
  source_address_prefix     = "*" # in theory you put your IP address here. It didn't work with mine BUT I'm behind an ISP that may be using NAT.
  destination_address_prefix = "*" # CIDR
  resource_group_name        = azurerm_network_security_group.CA.resource_group_name #who and what we want to be able to access
  network_security_group_name = azurerm_network_security_group.CA.name
}