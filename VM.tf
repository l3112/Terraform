
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

 