#Terraform Version 1.2.2 is required
terraform {
  required_version = ">= 1.2.2"
}


# Creating Public Subnet in VPC
resource "aws_subnet" "public-subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr_block-pub
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone-pub
  tags = {
    Name = "${var.subnet_tag_name-pub} public"
  }
}

# Creating Private Subnet in VPC
resource "aws_subnet" "private-subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr_block-priv
  map_public_ip_on_launch = "false"
  availability_zone       = var.availability_zone-priv
  tags = {
    Name = "${var.subnet_tag_name-priv} private"
  }

}

# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "aws-gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.internet_gateway_tag_name
  }
}

# Creating Route Tables for Internet Gateway
resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = var.rt_route
    gateway_id = aws_internet_gateway.aws-gw.id
  }

  tags = {
    Name = var.route_table_tag_name
  }
}

# Creating Route Associations public subnet
resource "aws_route_table_association" "pub_rt_association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.route_table.id
}

# Create Private key for public Instance
resource "tls_private_key" "pub_inst_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create Key pair for public Instance
resource "aws_key_pair" "pub_inst_generated_key" {
  key_name   = var.key_pair_names[0]
  public_key = tls_private_key.pub_inst_private_key.public_key_openssh
}

# Create .pem file for public Instance
resource "local_sensitive_file" "pub_pem_file" {
  filename = pathexpand("./${aws_key_pair.pub_inst_generated_key.key_name}.pem")
  file_permission = "600"
  directory_permission = "700"
  content = tls_private_key.pub_inst_private_key.private_key_pem
}

# Create Private key for private Instance
resource "tls_private_key" "priv_inst_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create Key pair for private Instance
resource "aws_key_pair" "priv_inst_generated_key" {
  key_name   = var.key_pair_names[1]
  public_key = tls_private_key.priv_inst_private_key.public_key_openssh
}

# Create .pem file for private Instance
resource "local_sensitive_file" "priv_pem_file" {
  filename = pathexpand("./${aws_key_pair.priv_inst_generated_key.key_name}.pem")
  file_permission = "600"
  directory_permission = "700"
  content = tls_private_key.priv_inst_private_key.private_key_pem
}

# Create Public ec2 instance
resource "aws_instance" "ec2_instance_public" {
  ami           = var.public_ec2_ami
  instance_type = var.public_instance_type
  subnet_id     = aws_subnet.public-subnet.id
  key_name      = aws_key_pair.pub_inst_generated_key.key_name

  tags = {
    Name = "${var.pub_ec2_instance_name} public instance"
  }
}

# Create Private ec2 instance
resource "aws_instance" "ec2_instance_private" {
  ami           = var.private_ec2_ami
  instance_type = var.private_instance_type
  subnet_id     = aws_subnet.private-subnet.id
  key_name      = aws_key_pair.priv_inst_generated_key.key_name

  tags = {
    Name = "${var.priv_ec2_instance_name} private instance"
  }
}

# Security Group for RDP
resource "aws_security_group" "rdp_security_group" {
  name = "allow_rdp"
  description = "A security group that allows inbound RDP traffic (TCP port 3389)."
  vpc_id = var.vpc_id

  ingress {
    description      = "RDP Access"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_rdp"
  }
}

# Security Security Group attachment for public instance
resource "aws_network_interface_sg_attachment" "pub_sg_attachment" {
  security_group_id    = aws_security_group.rdp_security_group.id
  network_interface_id = aws_instance.ec2_instance_public.primary_network_interface_id
}

# Security Security Group attachment for private instance
resource "aws_network_interface_sg_attachment" "priv_sg_attachment" {
  security_group_id    = aws_security_group.rdp_security_group.id
  network_interface_id = aws_instance.ec2_instance_private.primary_network_interface_id
}