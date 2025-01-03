variable "base_domain_name" {
  description = "Primary domain name"
  type        = string
  default     = ""
}

variable "subdomain_name" {
  description = "Subdomain delegation and Certificate"
  type        = string
  default     = ""
}

variable "subject_alternative_names" {
  description = "Extra Subject alternative names"
  type        = list(string)
  default     = []
}
