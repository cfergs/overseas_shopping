/*
Make sure to create a provider.tf file and populate with azure values. Otherwise you can't login!!

Also you should only need to update the location variable.
*/

#all global variables for environment

variable "location" {
  description = "The location/region where objects are created. Changing this forces a new resource to be created."
  default     = "Australia East"
  type        = string
}

variable "username" {
  description = "username for local administrator login account"
  default     = "shoppingvm"
  type        = string
}

variable "res_grp" {
  description = "The name of the resource group in which the resources will be created"
  default     = "shopping_grp"
  type        = string
}

variable "vm_size" {
  description = "VM size"
  default     = "Standard_D8a_v4"
  type        = string
}

variable "vm_image_publisher" {
  description = "The name of the publisher of the image that you want to deploy."
  default     = "MicrosoftWindowsDesktop"
  type        = string
}

variable "vm_image_offer" {
  description = "The name of the offer of the image that you want to deploy."
  default     = "windows-11"
  type        = string
}

variable "vm_image_sku" {
  description = "The sku of the image you want to deploy."
  default     = "win11-22h2-pro"
  type        = string
}

variable "vm_image_version" {
  description = "The version of the image you want to deploy."
  default     = "latest"
  type        = string
}
