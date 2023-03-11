resource "azurerm_network_interface" "catapp-nic" {
  name                      = "${var.prefix}-catapp-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.myresourcegroup.name

  ip_configuration {
    name                          = "${var.prefix}ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.catapp-pip.id
  }
}

resource "azurerm_network_interface" "hcp-worker-nic" {
  name                      = "${var.prefix}-hcp-worker-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.myresourcegroup.name

  ip_configuration {
    name                          = "${var.prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hcp-worker-pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "catapp-nic-sg-ass" {
  network_interface_id      = azurerm_network_interface.catapp-nic.id
  network_security_group_id = azurerm_network_security_group.catapp-sg.id
}

resource "azurerm_network_interface_security_group_association" "hcp-worker-nic-sg-ass" {
  network_interface_id      = azurerm_network_interface.hcp-worker-nic.id
  network_security_group_id = azurerm_network_security_group.catapp-sg.id
}

resource "azurerm_public_ip" "catapp-pip" {
  name                = "${var.prefix}-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}-meow"
}

resource "azurerm_public_ip" "hcp-worker-pip" {
  name                = "${var.prefix}-hcp-worker-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}-hcp-worker"
}

resource "azurerm_linux_virtual_machine" "hcp-worker" {
  name                = "${var.prefix}-hcp-worker-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  size             = var.vm_size

  network_interface_ids         = [azurerm_network_interface.hcp-worker-nic.id]

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_disk {
    name              = "${var.prefix}-osdisk-hcp-worker"
    storage_account_type = "Standard_LRS"
    caching           = "ReadWrite"
    #create_option     = "FromImage"
  }


  computer_name  = "${var.prefix}-hcp-worker"
  admin_username = var.admin_username
  admin_password = var.admin_password
  #custom_data = base64encode(local.custom_data)

  tags = {}

  admin_ssh_key {
    username   = "hashicorp"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }
  # Added to allow destroy to work correctly.
  depends_on = [azurerm_network_interface_security_group_association.hcp-worker-nic-sg-ass]
}

resource "azurerm_linux_virtual_machine" "linux-vm" {
  name                = "${var.prefix}-linux-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  size             = var.vm_size

  network_interface_ids         = [azurerm_network_interface.catapp-nic.id]
  #delete_os_disk_on_termination = "true"

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_disk {
    name              = "${var.prefix}-osdisk"
    storage_account_type  = "Standard_LRS"
    caching           = "ReadWrite"
    #create_option     = "FromImage"
  }


    computer_name  = "${var.prefix}-linux-vm"
    admin_username = var.admin_username
    admin_password = var.admin_password
    #custom_data = local.custom_data

  tags = {}

  admin_ssh_key {
    username   = "hashicorp"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  # Added to allow destroy to work correctly.
  depends_on = [azurerm_network_interface_security_group_association.catapp-nic-sg-ass]
}

resource "azurerm_windows_virtual_machine" "azure-rdp-vm" {
  name                = "azure-rdp-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.azure-windows-vm-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "azure-windows-vm-nic" {
  name                = "azure-windows-vm-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azure-windows-vm-nic-pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "azure-windows-vm-nic-sg-ass" {
  network_interface_id      = azurerm_network_interface.azure-windows-vm-nic.id
  network_security_group_id = azurerm_network_security_group.catapp-sg.id
}

resource "azurerm_public_ip" "azure-windows-vm-nic-pip" {
  name                = "${var.prefix}-rdp-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}-rdp-vm"
}