terraform {
  required_version = ">= 1.2.2"
}

provider "aws" {
  region                   = "us-west-1"
  shared_credentials_files = ["/Users/tre/.aws/credentials"]
}

# Creates VPC, IPv4 CIDR, DNS Support & Name, and Tags
resource "aws_vpc" "dev" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "dev-test"
  }
}


module "create_secure_ec2_instance" {
  source         = "../../modules/private_ec2_instance"
  vpc_id         = aws_vpc.dev.id
  vpc_cidr_block = "10.0.0.0/16"

  subnet_cidr_block-pub  = "10.0.1.0/24"
  subnet_cidr_block-priv = "10.0.2.0/24"

  subnet_tag_name-pub  = "dev-subnet-pub"
  subnet_tag_name-priv = "dev-subnet-priv"

  availability_zone-pub  = "us-west-1a"
  availability_zone-priv = "us-west-1b"

  internet_gateway_tag_name = "dev-gw"
  route_table_tag_name      = "dev-rt"
  rt_route                  = "0.0.0.0/0"

  pub_ec2_instance_name = "public_dev_test"
  public_ec2_ami        = "ami-0924e2d3a82e9782b"
  public_instance_type  = "t2.micro"
  key_pair_names        = ["pub_instance_key", "priv_instance_key"]

  priv_ec2_instance_name = "private_dev_test"
  private_ec2_ami        = "ami-0924e2d3a82e9782b"
  private_instance_type  = "t2.micro"

  
}
