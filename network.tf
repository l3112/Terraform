#this is the virtual network

resource "azurerm_virtual_network" "CA-vnet" {
    name                = "CA-vnet"
    location            = var.location
    resource_group_name = var.resourceGroupName 
    address_space       = [ "10.0.0.0/16" ]
    dns_servers         = ["8.8.8.8"] #you probably have some DNS servers

    tags = {
        enviroment  = "test"
    }
}

output "subnet" {
    value = azurerm_virtual_network.CA-vnet.subnet
  }



#new - may need deletion - it works, put in final product

resource "azurerm_network_interface" "CA-NetInt" {
 
 name                = "Net-Connection" 
 location            = var.location
 resource_group_name = var.resourceGroupName

  ip_configuration {
   name                          = "testConfiguration"
   subnet_id                     = azurerm_subnet.CA-sub.id
   private_ip_address_allocation = "dynamic"
   public_ip_address_id = azurerm_public_ip.CA-publicIP.id #double check
  }
} 

output "DNS-Out" {
    value = azurerm_network_interface.CA-NetInt.dns_servers
  }

output "DNS-Serv" {
    value = azurerm_network_interface.CA-NetInt.applied_dns_servers
}
#subnet 

resource "azurerm_subnet" "CA-sub" {
    name                    = "testsub"
    resource_group_name     = azurerm_network_security_group.CA.resource_group_name
    virtual_network_name    = azurerm_virtual_network.CA-vnet.name
    address_prefix          = "10.0.1.0/24"
}

#public IP address

resource "azurerm_public_ip" "CA-publicIP" {
    name                    = "CA-publicIP"
    location                = "eastus"
    resource_group_name     = azurerm_network_security_group.CA.resource_group_name
   allocation_method        = "Static"
   ip_version               = "IPv4"
  
  tags = {
      enviroment = "test"
            } 
} 
