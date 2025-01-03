output "eks" {
  description = "EKS Output"
  value = {
    cluster_endpoint                   = module.eks.cluster_endpoint
    cluster_name                       = module.eks.cluster_name
    cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  }
}

output "cloudflare_egress_ipv4" {
  description = "Cloudflare ZT static egress ipv4 addresses"
  value       = module.zt_whitelist.cloudflare_egress_ipv4
}
