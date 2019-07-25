/*
Make sure to create a provider.tf file and populate with azure values. Otherwise you can't login!!
*/

# create a resource group 
resource "azurerm_resource_group" "res_grp" {
  name 		    = "${var.res_grp}"
  location 	  = "${var.location}"
}

resource "azurerm_virtual_network" "virtualNetwork" {
  name                = "shopping_VNET"
  address_space       = ["10.99.0.0/16"]
  resource_group_name = "${azurerm_resource_group.res_grp.name}"
  location            = "${var.location}"
}

resource "azurerm_subnet" "subnet"	{
  name			  		      = "shopping_subnet"
	resource_group_name 	= "${azurerm_resource_group.res_grp.name}"
	virtual_network_name 	= "${azurerm_virtual_network.virtualNetwork.name}"
	address_prefix	  		= "10.99.1.0/24"
}

resource "azurerm_public_ip" "pubip"	{
  name                    = "shopping-ip"
  location 								= "${var.location}"
	resource_group_name 		= "${azurerm_resource_group.res_grp.name}"
	allocation_method 			= "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                    = "shopping-nic"
  location			 					= "${var.location}"
  resource_group_name 		= "${azurerm_resource_group.res_grp.name}"
  
  ip_configuration {
  	name                            = "shopping"
    subnet_id                       = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation   = "dynamic"
		public_ip_address_id            = "${azurerm_public_ip.pubip.id}"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "shoppingvm"
  resource_group_name 	= "${azurerm_resource_group.res_grp.name}"
  location             	= "${var.location}"
  vm_size               = "${var.vm_size}"

  delete_os_disk_on_termination     = "true"
  delete_data_disks_on_termination  = "true"
  
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]

  storage_image_reference {
    publisher = "${var.vm_image_publisher}"
    offer     = "${var.vm_image_offer}"
    sku       = "${var.vm_image_sku}"
    version   = "${var.vm_image_version}"
  }
  
  storage_os_disk	{
		name          = "osdisk-shoppingvm"
		create_option = "FromImage"
	}

  os_profile	{
		computer_name   = "shoppingvm"
		admin_username  = "shoppingvm"
		admin_password  = "${var.password}"
	}
	
  os_profile_windows_config	{
		provision_vm_agent 				= true
		enable_automatic_upgrades = true
  	timezone 								  = "W. Australia Standard Time"
  }
}