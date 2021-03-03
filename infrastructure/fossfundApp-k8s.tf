# This file is used by the exampleApp-k8s application.  The entries in here are for that application only.

locals {
  app_name   = "fossfundApp-k8s"
  namespaces = ["dev", "prod", "test"]
}

# module "exampleApp-pv" {
#   source = "git::git@github.com:jhu-library-operations/tf-mod-aws-efs-pv-k8s.git"
#   #source = "../../tf-mod-aws-efs-pv-k8s"
#   project_name          = local.app_name
#   output_path           = format("../manifests/apps/%s/overlays/aws/", local.app_name)
#   subnet_ids            = module.tf_k8s_cluster.subnet_ids
#   volume_label          = "webvol"
#   volume_capacity       = "5Gi"
#   volume_access_mode    = "ReadWriteMany"
#   volume_reclaim_policy = "Retain"
#   tags                  = local.tags
#   vpc_id                = module.tf_k8s_cluster.vpc_id
#   vpc_cidr_block        = module.tf_k8s_cluster.cidr_block
#   namespaces            = local.namespaces

# }

# module "testpv-dev" {
#   source = "git::git@github.com:jhu-library-operations/tf-mod-aws-efs-pv-k8s.git"
#   #source = "../../tf-mod-aws-efs-pv-k8s"
#   project_name          = local.app_name
#   output_path           = format("../manifests/apps/%s/overlays/aws/dev/volumes/testpv", local.app_name)
#   subnet_ids            = module.tf_k8s_cluster.subnet_ids
#   volume_label          = "testvol-dev"
#   volume_capacity       = "5Gi"
#   volume_access_mode    = "ReadWriteMany"
#   volume_reclaim_policy = "Retain"
#   tags                  = local.tags
#   vpc_id                = module.tf_k8s_cluster.vpc_id
#   vpc_cidr_block        = module.tf_k8s_cluster.cidr_block
#  # namespaces            = namespaces
#    namespaces            = [ "dev" ]

# }

# module "testpv-test" {
#   source = "git::git@github.com:jhu-library-operations/tf-mod-aws-efs-pv-k8s.git"
#   #source = "../../tf-mod-aws-efs-pv-k8s"
#   project_name          = local.app_name
#   output_path           = format("../manifests/apps/%s/overlays/aws/test/volumes/testpv", local.app_name)
#   subnet_ids            = module.tf_k8s_cluster.subnet_ids
#   volume_label          = "testvol-test"
#   volume_capacity       = "5Gi"
#   volume_access_mode    = "ReadWriteMany"
#   volume_reclaim_policy = "Retain"
#   tags                  = local.tags
#   vpc_id                = module.tf_k8s_cluster.vpc_id
#   vpc_cidr_block        = module.tf_k8s_cluster.cidr_block
#   namespaces            = [ "test" ]
# }

# module "testpv-prod" {
#   source = "git::git@github.com:jhu-library-operations/tf-mod-aws-efs-pv-k8s.git"
#   #source = "../../tf-mod-aws-efs-pv-k8s"
#   project_name          = local.app_name
#   output_path           = format("../manifests/apps/%s/overlays/aws/prod/volumes/testpv", local.app_name)
#   subnet_ids            = module.tf_k8s_cluster.subnet_ids
#   volume_label          = "testvol-prod"
#   volume_capacity       = "5Gi"
#   volume_access_mode    = "ReadWriteMany"
#   volume_reclaim_policy = "Retain"
#   tags                  = local.tags
#   vpc_id                = module.tf_k8s_cluster.vpc_id
#   vpc_cidr_block        = module.tf_k8s_cluster.cidr_block
#   namespaces            = [ "prod" ]
# }
