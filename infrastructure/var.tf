# variables needed for the second apply.
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "(optional) Used for creating the app's resources.  This can be different from admin_reagion. (default: us-east-1)"
}

variable "admin_region" {
  type        = string
  description = "(optional) Used for Admin operations (ie: route53/permissions stuff.)"
  default     = "us-east-1"
}
variable "network_id" {
  type        = string
  description = "(optional) Used only on pre-configured clound instances, ie internal ones, when the networking cannot be managed by Terrraform"
}

variable "private_subnets" {
  type        = list(string)
  description = "(optional) Used only on pre-configured clound instances, ie internal ones, when the networking cannot be managed by Terrraform"
}

variable "project_prefix" {
  type        = string
  description = "(Required) This is appeneded to most resource names and is used for project tracking."
}

variable "rg_name" {
  type        = string
  description = "(Required for Azure only) The Azure resource group to create the resources in"
}

variable "internal" {
  type        = bool
  description = "(Required) Bool false - creates Network Resources; true-relies on them already existing."
}

variable "ssh_key_public" {
  type        = string
  description = "(Required) Azure: Path to the public key to use; AWS: Name of the EC2 key to use"
}

variable "workers" {
  type        = number
  description = "(Optional) The number of 'Workers' (AWS: EC2 instances, AZURE: agents) (default: 4)"
  default     = 4
}

variable "tags" {
  type        = map
  default     = {}
  description = "(Optional) A map of tags"
}

variable "aws_role_arn" {
  type        = string
  default     = ""
  description = "(Required) For AWS: The role to assume when creating the app resources"

}

variable "aws_admin_role_arn" {
  type        = string
  description = "(Required) The arn for the MSEL-OPS Admin role, used for creating DNS records and authorization stuff."
}

variable "aws_route53_zone" {
  type        = string
  description = "(Required) The parent zone ID to create our subdomain in."
}

variable "namespaces" {
  type        = list
  description = "(Required) A list of the kubernetes namespaces you are going to be using."
}