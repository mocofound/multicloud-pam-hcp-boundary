# Get latest Windows Server 2019 AMI
data "aws_ami" "windows-2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}

# Create EC2 Instance
resource "aws_instance" "windows-server" {
  ami = data.aws_ami.windows-2019.id
  instance_type = var.windows_instance_type
  key_name                    = aws_key_pair.boundary_poc.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.boundary_poc.id
  vpc_security_group_ids      = [aws_security_group.boundary_poc.id]
  source_dest_check = false
  #user_data = data.template_file.windows-userdata.rendered 
  
  tags = {
    Name = "${var.prefix}-zurich-app1234-server"
  }

  # root disk
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }
  # extra disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.windows_data_volume_size
    volume_type           = var.windows_data_volume_type
    encrypted             = true
    delete_on_termination = true
  }



}

# Create Elastic IP for the EC2 instance
resource "aws_eip" "windows-eip" {
  vpc  = true
  tags = {
    Name = "windows-eip"
  }

}
# Associate Elastic IP to Windows Server
resource "aws_eip_association" "windows-eip-association" {
  instance_id   = aws_instance.windows-server.id
  allocation_id = aws_eip.windows-eip.id
}

variable "windows_instance_type" {
  type        = string
  description = "EC2 instance type for Windows Server"
  default     = "t2.small"
}
variable "windows_associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address to the EC2 instance"
  default     = true
}
variable "windows_root_volume_size" {
  type        = number
  description = "Volume size of root volumen of Windows Server"
  default     = 30
}
variable "windows_data_volume_size" {
  type        = number
  description = "Volume size of data volumen of Windows Server"
  default     = 10
}
variable "windows_root_volume_type" {
  type        = string
  description = "Volume type of root volumen of Windows Server."
  default     = "gp2"
}
variable "windows_data_volume_type" {
  type        = string
  description = "Volume type of data volumen of Windows Server."
  default     = "gp2"
}
variable "windows_instance_name" {
  type        = string
  description = "EC2 instance name for Windows Server"
  default     = "tfwinsrv01"
}


# # Bootstrapping PowerShell Script
# data "template_file" "windows-userdata" {
#   template = <<EOF
# <powershell>
# # Rename Machine
# #Rename-Computer -NewName "${var.windows_instance_name}" -Force;
# # Install IIS
# #Install-WindowsFeature -name Web-Server -IncludeManagementTools;
# # Restart machine
# #shutdown -r -t 10;
# </powershell>
# EOF
# }


# Create EC2 Instance
resource "aws_instance" "windows-server-rdp-client" {
  ami = data.aws_ami.windows-2019.id
  instance_type = var.windows_instance_type
  key_name                    = aws_key_pair.boundary_poc.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.boundary_poc.id
  vpc_security_group_ids      = [aws_security_group.boundary_poc.id]
  source_dest_check = false
  #user_data = data.template_file.windows-userdata.rendered 
  
  # root disk
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }
  # extra disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.windows_data_volume_size
    volume_type           = var.windows_data_volume_type
    encrypted             = true
    delete_on_termination = true
  }

    tags = {
    Name = "${var.prefix}-windows-server-rdp-client"
  }

}

# Create Elastic IP for the EC2 instance
resource "aws_eip" "windows-eip-2" {
  vpc  = true
  tags = {
    Name = "windows-eip-2"
  }

}
# Associate Elastic IP to Windows Server
resource "aws_eip_association" "windows-eip-association-2" {
  instance_id   = aws_instance.windows-server-rdp-client.id
  allocation_id = aws_eip.windows-eip-2.id
}

output "rdp_client_public_ip" {
  value = aws_instance.windows-server-rdp-client.public_dns
}