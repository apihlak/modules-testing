locals {

  managed_node_groups = {
    for g in keys(var.cluster_node_groups) :
    g => {

      iam_role_name            = "${module.label.id}-${g}" # Backwards compat
      iam_role_use_name_prefix = false                     # Backwards compat

      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }

      # defaults should not ever happen
      instance_types       = lookup(lookup(var.cluster_node_groups, g, {}), "instance_types", [])
      ami_type             = lookup(lookup(var.cluster_node_groups, g, {}), "ami_type", "AL2_x86_64")
      min_size             = lookup(lookup(var.cluster_node_groups, g, {}), "min_size", 0)
      max_size             = lookup(lookup(var.cluster_node_groups, g, {}), "max_size", 0)
      desired_size         = lookup(lookup(var.cluster_node_groups, g, {}), "desired_size", 0)
      force_update_version = lookup(lookup(var.cluster_node_groups, g, {}), "force_update_version", false)
      name                 = lookup(lookup(var.cluster_node_groups, g, {}), "name", module.label.id)
      subnet_ids           = lookup(lookup(var.cluster_node_groups, g, {}), "subnet_ids", var.private_subnets)
      update_config = lookup(lookup(var.cluster_node_groups, g, {}), "update_config", {
        max_unavailable_percentage = 33
      })
      capacity_type              = split("-", g)[0] == "on_demand" ? "ON_DEMAND" : "SPOT"
      use_custom_launch_template = true
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            encrypted             = true
            delete_on_termination = true
            volume_type           = "gp3"
            volume_size           = lookup(lookup(var.cluster_node_groups, g, {}), "volume_size", 20)
          }
        }
      }

      labels = {
        Which = split("-", g)[0] == "on_demand" ? "on-demand" : "spot"
      }
    }
  }

  cluster_endpoint_public_access_cidrs = concat(
    module.zt_whitelist.cloudflare_egress_ipv4, # Give access to Cloudflare ZT static egress ipv4 addresses
    var.cluster_endpoint_public_access_cidrs,
  )
}
