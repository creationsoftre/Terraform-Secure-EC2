# Terraform-Secure-EC2
Creating a VPC with two EC2 Instance. One Public EC2 Instance that communicates with a Private EC2 utilizing Terrafom. 

Steps completed in the terrafrom script:
1. Creates VPC, IPv4 CIDR, DNS Support & Name, and Tags
2. Creating Public Subnet in VPC
3. Creating Private Subnet in VPC
4. Creating Internet Gateway in AWS VPC
5. Creating Route Tables for Internet Gateway
6. Creating Route Associations public subnet
7. Create Private key for public Instance
8. Create Key pair for public Instance
9. Create .pem file for public Instance
10. Create Private key for private Instance
11. Create Key pair for private Instance
12. Create .pem file for private Instance
13. Create Public ec2 instance
14. Create Private ec2 instance
15. Security Group for RDP
16. Security Security Group attachment for public instance
17. Security Security Group attachment for private instance

How to use Script:
1. Update provider with your credentials or use another method to connect to you AWS account
2. update vpc cidr block 
3. update vpc tags
4. update variables in module "create_secure_ec2_instance" in main.tf
5. once all updated terrafrom is ready to be executed.
