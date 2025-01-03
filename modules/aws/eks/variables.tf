variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the cluster security group will be provisioned"
}

variable "private_subnets" {
  type        = list(string)
  default     = []
  description = "A list of private subnet IDs"
}

variable "public_subnets" {
  type        = list(string)
  default     = []
  description = "A list of public subnet IDs"
}

variable "cluster_version" {
  type        = string
  default     = null
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.27`)"
}

variable "aws_auth_users" {
  description = "List of IAM roles to add to the aws-auth configmap"
  type = list(object({
    userarn  = string
    username = string
  }))
  default = []
}

variable "cluster_node_groups" {
  description = "Configuration for the managed node groups in the EKS cluster. This should be a map with keys for each node group and values that are maps with the following keys."
  type        = any
  # example:
  #
  # cluster_node_groups = {
  #   on_demand = {
  #     instance_types = ["m4.large"]
  #     min_size       = 1
  #     max_size       = 2
  #     desired_size   = 1
  #   }
  #   spot = {
  #     instance_types = ["m5d.large", "m4.large", "m5.large", "m5a.large", "m3.large"]
  #     min_size       = 1
  #     max_size       = 3
  #     desired_size   = 1
  #   }
  # }
  validation {
    condition = alltrue([
      for g in keys(var.cluster_node_groups) :
      contains(["spot", "on_demand"], split("-", g)[0]) &&
      lookup(lookup(var.cluster_node_groups, g, {}), "instance_types", null) != null &&
      lookup(lookup(var.cluster_node_groups, g, {}), "min_size", null) != null &&
      lookup(lookup(var.cluster_node_groups, g, {}), "max_size", null) != null &&
      lookup(lookup(var.cluster_node_groups, g, {}), "desired_size", null) != null &&
      lookup(lookup(var.cluster_node_groups, g, {}), "volume_size", null) != null
    ])
    error_message = "cluster_node_groups is malformed, check the format in the doc"
  }
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = []
}

################################################################################
# Add-ons
################################################################################

variable "eks_addons" {
  description = "Map of EKS add-on configurations to enable for the cluster. Add-on name can be the map keys or set with `name`"
  type        = any
  default = {
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }
}

variable "enable_external_dns" {
  description = "Enable external-dns operator add-on"
  type        = bool
  default     = true
}

variable "external_dns_route53_zone_arns" {
  description = "List of Route53 zones ARNs which external-dns will have access to create/manage records (if using Route53)"
  type        = list(string)
  default     = []
}

variable "enable_aws_load_balancer_controller" {
  description = "Enable AWS Load Balancer Controller add-on"
  type        = bool
  default     = true
}

variable "enable_cluster_autoscaler" {
  description = "Enable Cluster Autoscaler controller add-on"
  type        = bool
  default     = true
}

variable "enable_external_secrets" {
  description = "Enable external-secrets operator add-on"
  type        = bool
  default     = true
}

variable "enable_metrics_server" {
  description = "Enable metrics server add-on	"
  type        = bool
  default     = true
}
