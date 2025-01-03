data "aws_caller_identity" "this" {}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

module "zt_whitelist" {
  source = "https://yolo-terraform-modules.s3.eu-central-1.amazonaws.com/defaults/whitelist-v0.0.4.tar.gz"
}
