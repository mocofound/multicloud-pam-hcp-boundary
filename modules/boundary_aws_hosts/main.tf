locals  {
  boundary_egress_cidr_ranges = ["35.168.53.57/32","34.232.124.174/32","44.194.155.74/32","0.0.0.0/0"]
  #boundary_egress_cidr_ranges = ["35.168.53.57/32","34.232.124.174/32","44.194.155.74/32"]
}

resource "aws_vpc" "boundary_poc" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-vpc-${var.region}"
    environment = "Production"
  }
}

resource "aws_subnet" "boundary_poc" {
  vpc_id     = aws_vpc.boundary_poc.id
  cidr_block = var.subnet_prefix
  availability_zone = "${var.region}a"
  
  tags = {
    Name = "${var.prefix}-subnet-a"
  }
}

resource "aws_subnet" "boundary_poc_2" {
  vpc_id     = aws_vpc.boundary_poc.id
  cidr_block = var.subnet_prefix_2
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.prefix}-subnet-b"
  }
}

resource "aws_security_group" "boundary_poc" {
  name = "${var.prefix}-security-group"

  vpc_id = aws_vpc.boundary_poc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.boundary_egress_cidr_ranges
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = local.boundary_egress_cidr_ranges
    description = "Allow incoming RDP connections"
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = local.boundary_egress_cidr_ranges
  }

  ingress {
    from_port   = 9201
    to_port     = 9201
    protocol    = "tcp"
    cidr_blocks = local.boundary_egress_cidr_ranges
  }

  ingress {
    from_port   = 9202
    to_port     = 9202
    protocol    = "tcp"
    cidr_blocks = local.boundary_egress_cidr_ranges
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.prefix}-security-group"
  }
}

resource "aws_internet_gateway" "boundary_poc" {
  vpc_id = aws_vpc.boundary_poc.id

  tags = {
    Name = "${var.prefix}-internet-gateway"
  }
}

/*
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.boundary_poc.id
  subnet_id     = aws_subnet.boundary_poc.id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.boundary_poc]
}
*/

resource "aws_route_table" "boundary_poc" {
  vpc_id = aws_vpc.boundary_poc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.boundary_poc.id
  }
}
/*
resource "aws_route_table" "boundary_poc_private" {
  vpc_id = aws_vpc.boundary_poc.id

  route {
    cidr_block = "0.0.0.0/0"
    
  }
}
*/

resource "aws_route_table_association" "boundary_poc" {
  subnet_id      = aws_subnet.boundary_poc.id
  route_table_id = aws_route_table.boundary_poc.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-disco-19.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_eip" "boundary_poc" {
  instance = aws_instance.boundary_poc.id
  vpc      = true

  tags = {
    Name = "${var.prefix}-eip"
  }
}

resource "aws_eip_association" "boundary_poc" {
  instance_id   = aws_instance.boundary_poc.id
  allocation_id = aws_eip.boundary_poc.id
}

resource "aws_instance" "boundary_poc" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.boundary_poc.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.boundary_poc.id
  vpc_security_group_ids      = [aws_security_group.boundary_poc.id]

  tags = {
    Name = "${var.prefix}-instance"
  }
}

resource "aws_eip_association" "hcp_worker" {
  instance_id   = aws_instance.hcp_worker.id
  allocation_id = aws_eip.hcp_worker.id
}

resource "aws_eip" "hcp_worker" {
  instance = aws_instance.hcp_worker.id
  vpc      = true

  tags = {
    Name = "${var.prefix}-hcp-worker-eip"
  }
}

resource "aws_instance" "hcp_worker" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.boundary_poc.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.boundary_poc.id
  vpc_security_group_ids      = [aws_security_group.boundary_poc.id]
  user_data =  <<CUSTOM_DATA
  #!/bin/bash
  mkdir /home/ubuntu/boundary/ && cd /home/ubuntu/boundary/
  wget -q https://releases.hashicorp.com/boundary-worker/0.10.5+hcp/boundary-worker_0.10.5+hcp_linux_amd64.zip ;\
  sudo apt-get update && sudo apt-get install unzip ;\
  unzip *.zip
  cat << EOF > /home/ubuntu/boundary/pki-worker.hcl
  disable_mlock = true
  hcp_boundary_cluster_id = "7fd7b4f5-f38a-4570-9829-8bbc07b6b5a8"
  listener "tcp" {
    address = "0.0.0.0:9202"
    purpose = "proxy"
  }
  worker {
    public_addr = "ec2-3-216-70-46.compute-1.amazonaws.com"
    auth_storage_path = "/home/ubuntu/boundary/worker1"
    tags {
      type = ["worker", "dev", "aws"]
    }
  }
EOF

  nohup ./boundary-worker server -config="/home/ubuntu/boundary/pki-worker.hcl" -log-level="debug">> /home/ubuntu/boundary/output.txt &

CUSTOM_DATA

  tags = {
    Name = "${var.prefix}-hcp-worker-instance"
  }
}

# We're using a little trick here so we can run the provisioner without
# destroying the VM. Do not do this in production.

# If you need ongoing management (Day N) of your virtual machines a tool such
# as Chef or Puppet is a better choice. These tools track the state of
# individual files and can keep them in the correct configuration.

# Here we do the following steps:
# Sync everything in files/ to the remote VM.
# Set up some environment variables for our script.
# Add execute permissions to our scripts.
# Run the deploy_app.sh script.
resource "null_resource" "configure-cat-app" {
  depends_on = [aws_eip_association.boundary_poc]

  triggers = {
    build_number = timestamp()
  }

  # provisioner "file" {
  #   source      = "files/"
  #   destination = "/home/ubuntu/"

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = tls_private_key.boundary_poc.private_key_pem
  #     host        = aws_eip.boundary_poc.public_ip
  #   }
  # }
  /*
      "sudo apt -y install postgresql postgresql-contrib",
      "sudo -u postgres psql",
      "sudo chown -R ubuntu:ubuntu /etc/postgresql/10/main/postgresql.conf", 
      "echo "listen_addresses = '*'" >> /etc/postgresql/10/main/postgresql.conf",
      "sudo chown -R ubuntu:ubuntu /etc/postgresql/10/main/pg_hba.conf", 
      "echo "host    all             all              0.0.0.0/0                       md5" >> /etc/postgresql/10/main/pg_hba.conf",
      "echo "host    all             all              ::/0                       md5" >> /etc/postgresql/10/main/pg_hba.conf",
      "sudo systemctl start postgresql.service",
      "sudo -u postgres psql",
      "sleep 1",
      "\\q",
      "sleep 15",
      "\\q",
      "sudo apt -y update",
      "sleep 15",
      "sudo apt -y install apache2",
      "sudo systemctl start apache2",
      "sudo chown -R ubuntu:ubuntu /var/www/html",
      "chmod +x *.sh",
      "PLACEHOLDER=${var.placeholder} WIDTH=${var.width} HEIGHT=${var.height} PREFIX=${var.prefix} ./deploy_app.sh",

  */    
#Postgres Info: https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart
#  provisioner "remote-exec" {
#     inline = [
#       "sudo apt -y update",
#       "sudo apt -y install cowsay",
#       "cowsay Mooooooooooo!",
      
#     ]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = tls_private_key.boundary_poc.private_key_pem
#       host        = aws_eip.boundary_poc.public_ip
#     }
    
#   }
  
}

resource "tls_private_key" "boundary_poc" {
  algorithm = "RSA"
}

locals {
  private_key_filename = "${var.prefix}-ssh-key-2.pem"
}

resource "aws_key_pair" "boundary_poc" {
  key_name   = local.private_key_filename
  public_key = tls_private_key.boundary_poc.public_key_openssh
}

output "public_url" {
  value = "http://${aws_eip.boundary_poc.public_dns}"
}

output "public_ip" {
  value = "http://${aws_eip.boundary_poc.public_ip}"
}

output "aws_key_pair" {
  value = aws_key_pair.boundary_poc
}

output "ssh_private_key" {
  sensitive = true
  value = tls_private_key.boundary_poc.private_key_pem
}