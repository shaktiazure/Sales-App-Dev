variable "prefix" {
  default = "Sales-Dev"
}

#resource "azurerm_resource_group" "example" {
# name     = "${var.prefix}-resources"
#location = "West Europe"
#}

resource "azurerm_virtual_network" "Dev-Vnet" {
  name                = "${var.prefix}-network"
  address_space       = ["40.0.0.0/16"]
  location            = azurerm_resource_group.devRG.location
  resource_group_name = azurerm_resource_group.devRG.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.devRG.name
  virtual_network_name = azurerm_virtual_network.Dev-Vnet.name
  address_prefixes     = ["40.0.2.0/24"]
}

resource "azurerm_network_interface" "Dev-nic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.devRG.location
  resource_group_name = azurerm_resource_group.devRG.name

  ip_configuration {
    name                          = "Dev-IP1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "Dev-VM" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.devRG.location
  resource_group_name   = azurerm_resource_group.devRG.name
  network_interface_ids = [azurerm_network_interface.Dev-nic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "Sales-Dev-VM"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
    Deplyby     = "Terraform"
  }
}