provider "azurerm" {
  version         = "2.0.0" #the latest. 2.0.0 is the old one
  subscription_id = var.subscriptionID

  features {}
}
# REMEMBER TO CHANGE TO THE CA2 WORKSPACE default is broken.
# terraform workspace select
#this is the network security group
resource "azurerm_network_security_group" "CA" {
    name                = "CA"
    location            = "eastus"
    resource_group_name = var.resourceGroupName
  
}
#this is a network rule. not a VM rule If you want to use SSH
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


# Create our Windows Server 2019
resource "azurerm_virtual_machine" "CloudAvailServ" {
  name                  = "WS201901"
  location              = var.location
  resource_group_name   = var.resourceGroupName
  network_interface_ids = ["${element(azurerm_network_interface.CA-NetInt.*.id, 01)}"] # the index is just the number you want
  depends_on            = [azurerm_network_interface.CA-NetInt] # placeholder for when a network interface is made 
  vm_size               = "Standard_B1s"

  

    storage_image_reference {
              publisher = "MicrosoftWindowsServer"
              offer     = "WindowsServer"
              sku       = "2019-Datacenter-Core"
              version   = "latest"
  } 

   
 os_profile_windows_config {
  }


    storage_os_disk {
    name              = "disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "CAServ"
    admin_username = "azureuser"
    admin_password = "3lWc7mrPd14?!"
  } 

  
  } 

  #puts the rules on the network interface

  resource "azurerm_network_interface_security_group_association" "RuleAttach" {
  network_interface_id      = azurerm_network_interface.CA-NetInt.id
  network_security_group_id = azurerm_network_security_group.CA.id
}
