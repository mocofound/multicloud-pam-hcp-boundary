locals {
  #boundary_egress_cidr_ranges = ["35.168.53.57/32","34.232.124.174/32","44.194.155.74/32","0.0.0.0/0"]
  boundary_egress_cidr_ranges = ["0.0.0.0/0"]
  custom_data = <<CUSTOM_DATA
  #!/bin/bash
  mkdir /home/hashicorp/boundary/ && cd /home/hashicorp/boundary/
  cat << EOF > /home/hashicorp/boundary/pki-worker.hcl
  disable_mlock = true
  hcp_boundary_cluster_id = "7fd7b4f5-f38a-4570-9829-8bbc07b6b5a8"
  listener "tcp" {
    address = "0.0.0.0:9202"
    purpose = "proxy"
  }
  worker {
    public_addr = "52.165.38.233"
    auth_storage_path = "/home/hashicorp/boundary/worker1"
    tags {
      #type = ["worker", "dev", "azure"]
      type = ["azure"]
    }
  }
EOF
  #curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - ;\
  #sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" ;\
  #sudo apt-get update && sudo apt-get install boundary ;\
  #boundary server -config="/home/hashicorp/pki-worker.hcl"
  wget -q https://releases.hashicorp.com/boundary-worker/0.11.0+hcp/boundary-worker_0.11.0+hcp_linux_amd64.zip ;\
  #sudo apt-get update && sudo apt-get install unzip ;\
  sudo apt-get install unzip ;\
  unzip *.zip


  nohup ./boundary-worker server -config="/home/hashicorp/boundary/pki-worker.hcl" >> /home/hashicorp/boundary/output.txt &
  #nohup boundary server -config="/home/hashicorp/boundary/pki-worker.hcl" >> /home/hashicorp/boundary/output.txt &
  CUSTOM_DATA
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
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

  # security_rule {
  #   name                       = "SSH"
  #   priority                   = 101
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "22"
  #   #source_address_prefix      = "*"
  #   source_address_prefixes = local.boundary_egress_cidr_ranges
  #   destination_address_prefix = "*"
  # }

  # security_rule {
  #   name                       = "Boundary Controller Worker"
  #   priority                   = 102
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "9201"
  #   #source_address_prefix      = "*"
  #   source_address_prefixes = local.boundary_egress_cidr_ranges
  #   destination_address_prefix = "*"
  # }

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