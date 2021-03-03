## Terraform Kubernetes 
#
# Usage: 
#   - Customize this file to fit your needs.  If a parameter is missing, and
#     you think it should be added, open a github issue
#   - Copy the customized file to the deployment/ directory
#   - Run 'terraform init -var-file=deployment/terraform.tfvars`
#   - You can then run 'terraform plan -var-file=deployment/terraform.tfvars`
#

# The AWS Role to assume for creating AWS resources.
aws_role_arn = "arn:aws:iam::005956675899:role/MselAdmins"

# The AWS Role for MSELOPS Admin actions.
aws_admin_role_arn = "arn:aws:iam::005956675899:role/MselAdmins"

# NO UNDERSCORES, ONLY HYPHENS!
project_prefix = "fossfund-k8s"

# AWS - the name of the EC2 ssh key to7 use
# Azure - the public key data itself.
ssh_key_public = "operations"


# The route53 parent zone ID to create our subdomain in
aws_route53_zone = "Z1I0I2RONNVZY1"

# tags to set on all resources that accept tags.
tags = {
  Project : "fossfund-k8s"
}

# if applicable, the resource group.  Set to "" if not needed
# AWS - unused, set to ""
# AZURE - the actual Resource Group
rg_name = ""

# if applicable, the region.  Set to "" if not needed
# AWS and Azure - This is the region
region = "us-east-1"

# this will let you set the underlying instance size/type for the provider
# each provider has a default: AWS: t2.medium; Azure: Standard_DC2s_v2
# Leaving this out and not setting it in main.tf will result in the default
# setting it here and on the 'tf_k8s_cluster' module will override the defaults
#instance_size = "Standard_DC2s_v2"

# This is an indication of if the cluster is on the JHU 
# internal cloud accounts (cannot create netowrk resources)
# or not.  If it's false, it will attempt to create
# the supporting network infrastructure.  If True, you must 
# specify it below.
internal = false

# the id of the underlying provider network you want to use.
# If "internal" is 'false', this value is ignored, but must be set to 
# at least "".
# AWS -  the VPC ID
# AZURE - the network name
# network_id = "vpc-0ff0c070114cf62a4"
network_id = ""

# A list of the CIDR subnets to use
# private_subnets = ["10.151.223.0/24", "10.151.222.0/24", "10.151.221.0/24"]
# If "internal" is 'false', this value is ignored, but must be set to 
# at least "".
private_subnets = [""]

namespaces = ["dev", "prod"]


### ADVANCED CONFIG - Here, there be dragons.  Add provider specific 
# stuff here
