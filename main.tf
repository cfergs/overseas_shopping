/*
Make sure to create a provider.tf file and populate with azure values. Otherwise you can't login!!
*/

# create a resource group
resource "azurerm_resource_group" "res_grp" {
  name     = var.res_grp
  location = var.location
}

# Create network infrastructure
resource "azurerm_virtual_network" "virtualNetwork" {
  name                = "shopping_VNET"
  address_space       = ["10.99.0.0/16"]
  resource_group_name = azurerm_resource_group.res_grp.name
  location            = var.location
}

resource "azurerm_subnet" "subnet" {
  name                 = "shopping_subnet"
  resource_group_name  = azurerm_resource_group.res_grp.name
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  address_prefixes     = ["10.99.1.0/24"]
}

resource "azurerm_public_ip" "pubip" {
  name                = "shopping-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.res_grp.name
  allocation_method   = "Dynamic"
}

# Get public IP address to limit access to specified ACL's that open access to dangerous ports
data "publicip_address" "ip_address" {
  source_ip = "0.0.0.0" # getting ipv4 only
}

# Security stuffs
resource "azurerm_network_security_group" "nsg" {
  name                = "shopping-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.res_grp.name
}

resource "azurerm_network_security_rule" "rule" {
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_resource_group.res_grp.name
  name                        = "3389"
  priority                    = "100"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = data.publicip_address.ip_address.ip
  destination_address_prefix  = "*"
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Everything VM related
resource "azurerm_network_interface" "nic" {
  #checkov:skip=CKV_AZURE_119: "Ensure that Network Interfaces don't use public IPs"
  name                = "shopping-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.res_grp.name

  ip_configuration {
    name                          = "shopping"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip.id
  }
}

# This creates the password for use - random_string allows output to screen
resource "random_string" "password_generation" {
  length  = 16
  special = true
}

resource "azurerm_windows_virtual_machine" "vm" {
  #checkov:skip=CKV2_AZURE_12: "Ensure that virtual machines are backed up using Azure Backup"
  #checkov:skip=CKV_AZURE_50: "Ensure Virtual Machine Extensions are not Installed"
  #checkov:skip=CKV_AZURE_151: "Ensure Windows VM enables encryption" - The property 'securityProfile.encryptionAtHost' is not valid because the 'Microsoft.Compute/EncryptionAtHost' feature is not enabled for this subscription.
  name                = "shoppingvm"
  resource_group_name = azurerm_resource_group.res_grp.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.username
  admin_password      = random_string.password_generation.result
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  timezone = "W. Australia Standard Time"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
}
