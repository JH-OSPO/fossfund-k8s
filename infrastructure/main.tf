# use an S3 backend.
terraform {
  backend "s3" {
    bucket = "msel-ops-terraform-statefiles"
    # CHANGE THIS LINE BELOW!!!
    key = "applications/fossfund-k8s" # CHANGE THIS!!!
    # SERIOUSLY, DID YOU CHANGE THE LINE ABOVE!!!
    region   = "us-east-1"
    role_arn = "arn:aws:iam::005956675899:role/MselAdmins"
  }
}

locals {
  common_tags = {
    Project = var.project_prefix
  }
  tags = merge(local.common_tags, var.tags)

}

module "tf_k8s_cluster" {
  # IF YOU CHANGE THIS, YOU MUST RUN 'terraform init'!!!
  source = "git::git@github.com:jhu-library-operations/tf-mod-aws-eks-k8s-cluster.git"

  cluster_name    = var.project_prefix
  tags            = local.tags
  network_id      = var.network_id
  private_subnets = var.private_subnets
  region          = var.region
  internal        = var.internal
  ssh_key_public  = var.ssh_key_public
  rg_name         = var.rg_name
  workers         = var.workers
  cluster_version = "1.18"

  # uncomment and set in terraform.tfvars to override default
  # instance_size  = var.instance_size

  # AWS: Used for cluster access after creation
  aws_role_arn = var.aws_role_arn

}

# create a route 53 subdomain for our application
module "tf_k8s_subdomain" {
  source         = "git::git@github.com:jhu-library-operations/terraform-aws-route53-subdomain.git"
  project_name   = var.project_prefix
  tags           = local.tags
  parent_zone_id = var.aws_route53_zone
  descr          = format("Subdomain for %s", var.project_prefix)
  providers = {
    aws = aws.mselops_admin
  }
}

# Generate the externalDNS IAM entries in the main account and
# generate the Yaml manifests into the 
# manifests/infrastructure/external-dns directory

module "k8s_externaldns" {
  providers = {
    aws = aws.mselops_admin
  }
  source       = "git::git@github.com:jhu-library-operations/terraform-aws-external-dns-k8s.git"
  project_name = var.project_prefix
  zone_id      = module.tf_k8s_subdomain.sub_zone_id
  output_path  = "../manifests/infrastructure/external-dns"
  tags         = local.tags
}

module "graylog_pv" {
  source = "git::git@github.com:jhu-library-operations/tf-mod-aws-efs-pv-k8s.git?ref=8219dfed2ff39e5e72086db05592787ab52afcac"
  project_name          = var.project_prefix
  output_path           = "../manifests/infrastructure/"
  subnet_ids            = module.tf_k8s_cluster.subnet_ids
  volume_label          = "graylog-pv"
  volume_capacity       = "80Gi"
  volume_access_mode    = "ReadWriteMany"
  volume_reclaim_policy = "Retain"
  tags                  = merge({ Name = "graylog-pv" }, local.tags)
  vpc_id                = module.tf_k8s_cluster.vpc_id
  vpc_cidr_block        = module.tf_k8s_cluster.cidr_block
  access_points = {
    "logging" : {
      uid : 1100
      gid : 1100
      c_uid : 1100
      c_gid : 1100
      c_permissions : 755
      path : "/graylog"
    }
  }
  namespaces = ["logging"]
}

module "graylog_mongo_pv" {
  source = "git::git@github.com:jhu-library-operations/tf-mod-aws-efs-pv-k8s.git?ref=8219dfed2ff39e5e72086db05592787ab52afcac"
  #source = "../../tf-mod-aws-efs-pv-k8s"
  project_name          = var.project_prefix
  output_path           = "../manifests/infrastructure/"
  subnet_ids            = module.tf_k8s_cluster.subnet_ids
  volume_label          = "graylog-mongo-pv"
  volume_capacity       = "20Gi"
  volume_access_mode    = "ReadWriteMany"
  volume_reclaim_policy = "Retain"
  tags                  = merge({ Name = "graylog-mongo-pv" }, local.tags)
  vpc_id                = module.tf_k8s_cluster.vpc_id
  vpc_cidr_block        = module.tf_k8s_cluster.cidr_block
  namespaces            = ["logging"]
}

module "graylog_es_pv" {
  source = "git::git@github.com:jhu-library-operations/tf-mod-aws-efs-pv-k8s.git?ref=8219dfed2ff39e5e72086db05592787ab52afcac"
  #source                = "../../tf-mod-aws-efs-pv-k8s"
  project_name          = var.project_prefix
  output_path           = "../manifests/infrastructure/"
  subnet_ids            = module.tf_k8s_cluster.subnet_ids
  volume_label          = "graylog-es-pv"
  volume_capacity       = "80Gi"
  volume_access_mode    = "ReadWriteMany"
  volume_reclaim_policy = "Retain"
  tags                  = merge({ Name = "graylog-es-pv" }, local.tags)
  vpc_id                = module.tf_k8s_cluster.vpc_id
  vpc_cidr_block        = module.tf_k8s_cluster.cidr_block
  access_points = {
    "logging" : {
      uid : 1000
      gid : 1000
      c_uid : 1000
      c_gid : 1000
      c_permissions : 755
      path : "/es"
    }
  }
  namespaces = ["logging"]
}


provider "kubernetes" {
  version          = "< 2.0.0"
  load_config_file = true
  config_path      = module.tf_k8s_cluster.kubeconfig_filename
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.aws_role_arn
  }
}

provider "aws" {
  alias  = "mselops_admin"
  region = var.admin_region
  assume_role {
    role_arn = var.aws_admin_role_arn
  }
}
