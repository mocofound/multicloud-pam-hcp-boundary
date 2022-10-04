locals {
  #boundary_egress_cidr_ranges = ["35.168.53.57/32","34.232.124.174/32","44.194.155.74/32","0.0.0.0/0"]
  boundary_egress_cidr_ranges = ["0.0.0.0/0"]
  custom_data = <<CUSTOM_DATA
  #!/bin/bash
  mkdir /home/hashicorp/boundary/ && cd /home/hashicorp/boundary/
  wget -q https://releases.hashicorp.com/boundary-worker/0.10.5+hcp/boundary-worker_0.10.5+hcp_linux_amd64.zip ;\
  sudo apt-get update && sudo apt-get install unzip ;\
  unzip *.zip
  cat << EOF > /home/hashicorp/boundary/pki-worker.hcl
  disable_mlock = true
  hcp_boundary_cluster_id = "7fd7b4f5-f38a-4570-9829-8bbc07b6b5a8"
  listener "tcp" {
    address = "0.0.0.0:9202"
    purpose = "proxy"
  }
  worker {
    public_addr = "20.9.49.102"
    auth_storage_path = "/home/hashicorp/boundary/worker1"
    tags {
      type = ["worker", "dev", "azure"]
    }
  }
EOF

  nohup ./boundary-worker server -config="/home/hashicorp/boundary/pki-worker.hcl" >> /home/hashicorp/boundary/output.txt &
  CUSTOM_DATA
}

resource "azurerm_resource_group" "myresourcegroup" {
  name     = "${var.prefix}-workshop"
  location = var.location

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.myresourcegroup.location
  address_space       = [var.address_space]
  resource_group_name = azurerm_resource_group.myresourcegroup.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.myresourcegroup.name
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_network_security_group" "catapp-sg" {
  name                = "${var.prefix}-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    #source_address_prefix      = "*"
    source_address_prefixes = local.boundary_egress_cidr_ranges
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Boundary Controller Worker"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9201"
    #source_address_prefix      = "*"
    source_address_prefixes = local.boundary_egress_cidr_ranges
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "Boundary Controller Worker 9202"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9202"
    #source_address_prefix      = "*"
    source_address_prefixes = local.boundary_egress_cidr_ranges
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "catapp-nic" {
  name                      = "${var.prefix}-catapp-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.myresourcegroup.name

  ip_configuration {
    name                          = "${var.prefix}ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    //public_ip_address_id          = azurerm_public_ip.catapp-pip.id
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

resource "azurerm_virtual_machine" "hcp-worker" {
  name                = "${var.prefix}-hcp-worker-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  vm_size             = var.vm_size

  network_interface_ids         = [azurerm_network_interface.hcp-worker-nic.id]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk-hcp-worker"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${var.prefix}-hcp-worker"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data = local.custom_data
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {}

  # Added to allow destroy to work correctly.
  depends_on = [azurerm_network_interface_security_group_association.hcp-worker-nic-sg-ass]
}

resource "azurerm_virtual_machine" "linux-vm" {
  name                = "${var.prefix}-linux-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  vm_size             = var.vm_size

  network_interface_ids         = [azurerm_network_interface.catapp-nic.id]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${var.prefix}-linux-vm"
    admin_username = var.admin_username
    admin_password = var.admin_password
    #custom_data = local.custom_data
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {}

  # Added to allow destroy to work correctly.
  #depends_on = [azurerm_network_interface_security_group_association.catapp-nic-sg-ass]
}