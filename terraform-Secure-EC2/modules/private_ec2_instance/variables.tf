variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Subnet cider block"
}

variable "subnet_cidr_block-pub" {
  type        = string
  description = "public subnet cider block"
}

variable "subnet_cidr_block-priv" {
  type        = string
  description = "public subnet cider block"
}

variable "availability_zone-pub" {
  type        = string
  description = "public availability zone"
}

variable "availability_zone-priv" {
  type        = string
  description = "private availability zone"
}

variable "rt_route" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Route Table Route. Default value is 0.0.0.0/0"
}

variable "key_pair_names" {
  type = list
  description = "key names for ec2 key pair"
  default = [
        "keyname1",
        "keyname2"
    ]
}

variable "public_ec2_ami" {
  type        = string
  description = "AMI to use on the webserver instance. Default value is Windows Server 2019 standard"
  default     = "ami-0924e2d3a82e9782b"
}

variable "private_ec2_ami" {
  type        = string
  description = "AMI to use on the webserver instance. Default value is Windows Server 2019 standard"
  default     = "ami-0924e2d3a82e9782b"
}

variable "public_instance_type" {
  type        = string
  description = "Instance type. Default value is t2.micro"
  default     = "t2.micro"
}

variable "private_instance_type" {
  type        = string
  description = "Instance type. Default value is t2.micro"
  default     = "t2.micro"
}


variable "pub_ec2_instance_name" {
  type        = string
  description = "The name of the EC2 Instance"
}

variable "priv_ec2_instance_name" {
  type        = string
  description = "The name of the EC2 Instance"
}

variable "route_table_tag_name" {
  type        = string
  description = "name for route table tag"
}

variable "internet_gateway_tag_name" {
  type        = string
  description = "name for internet gateway tag"
}

variable "subnet_tag_name-pub" {
  type        = string
  description = " name for public subnet tag"
}

variable "subnet_tag_name-priv" {
  type        = string
  description = " name for private subnet tag"
}
