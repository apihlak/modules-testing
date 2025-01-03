variable "engine_version" {
  description = "Version of the OpenSearch engine to use"
  type        = string
  default     = null
}

variable "cluster_config" {
  description = "Configuration block for the cluster of the domain"
  type        = any
  default     = {}
}

variable "ebs_options" {
  description = "Configuration block for EBS related options, may be required based on chosen [instance size](https://aws.amazon.com/elasticsearch-service/pricing/)"
  type        = any
  default     = {}
}

variable "advanced_security_options" {
  description = "Configuration block for [fine-grained access control](https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/fgac.html)"
  type        = any
  default = {
    enabled = false
  }
}

variable "access_policy_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type        = any
  default     = {}
}

variable "security_group_rules" {
  description = "Security group ingress and egress rules to add to the security group created"
  type        = any
  default     = {}
}

variable "auto_tune_options" {
  description = "Configuration block for the Auto-Tune options of the domain"
  type        = any
  default = {
    desired_state = "DISABLED"
  }
}

variable "log_publishing_options" {
  description = "Configuration block for publishing slow and application logs to CloudWatch Logs. This block can be declared multiple times, for each log_type, within the same resource"
  type        = any
  default = [
    { log_type = "INDEX_SLOW_LOGS" },
    { log_type = "SEARCH_SLOW_LOGS" },
  ]
}

variable "vpc_options" {
  description = "Configuration block for VPC related options. Adding or removing this configuration forces a new resource ([documentation](https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-vpc.html#es-vpc-limitations))"
  type        = any
  default     = {}
}

variable "vpc_endpoints" {
  description = "Configure connection between VPCs. Map of VPC endpoints to create for the domain"
  type        = any
  default     = {}
}

variable "vpc_endpoint_accounts_to_authorize" {
  description = "AWS account ID to grant access to"
  type        = list(string)
  default     = []
}
