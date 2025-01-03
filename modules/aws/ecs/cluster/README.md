<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_autoscaling"></a> [autoscaling](#module\_autoscaling) | terraform-aws-modules/autoscaling/aws | 8.0.0 |
| <a name="module_autoscaling_sg"></a> [autoscaling\_sg](#module\_autoscaling\_sg) | terraform-aws-modules/security-group/aws | 5.2.0 |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | terraform-aws-modules/ecs/aws//modules/cluster | 5.12.0 |
| <a name="module_label"></a> [label](#module\_label) | git::ssh://git@github.com/coingaming/infra-modules.git//modules/global/label | main |
| <a name="module_this"></a> [this](#module\_this) | git::ssh://git@github.com/coingaming/infra-modules.git//modules/global/label | main |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.ecs_optimized_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_autoscaling_group_tags"></a> [autoscaling\_group\_tags](#input\_autoscaling\_group\_tags) | A map of additional tags to add to the autoscaling group. https://github.com/hashicorp/terraform-provider-aws/issues/12582 | `map(string)` | <pre>{<br>  "AmazonECSManaged": true<br>}</pre> | no |
| <a name="input_autoscaling_managed_termination_protection"></a> [autoscaling\_managed\_termination\_protection](#input\_autoscaling\_managed\_termination\_protection) | Managed termination protection for auto-scaling groups. | `string` | `"ENABLED"` | no |
| <a name="input_autoscaling_maximum_scaling_step_size"></a> [autoscaling\_maximum\_scaling\_step\_size](#input\_autoscaling\_maximum\_scaling\_step\_size) | Maximum scaling step size for managed scaling. | `number` | `5` | no |
| <a name="input_autoscaling_minimum_scaling_step_size"></a> [autoscaling\_minimum\_scaling\_step\_size](#input\_autoscaling\_minimum\_scaling\_step\_size) | Minimum scaling step size for managed scaling. | `number` | `1` | no |
| <a name="input_autoscaling_status"></a> [autoscaling\_status](#input\_autoscaling\_status) | Managed scaling status. | `string` | `"ENABLED"` | no |
| <a name="input_capacity_provider"></a> [capacity\_provider](#input\_capacity\_provider) | User input for capacity providers. Options can include "on-demand", "spot" or any custom value | `string` | `"on-demand"` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "region": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_create"></a> [create](#input\_create) | Determines whether resources will be created (affects all resources) | `bool` | `true` | no |
| <a name="input_create_iam_instance_profile"></a> [create\_iam\_instance\_profile](#input\_create\_iam\_instance\_profile) | Determines whether an IAM instance profile is created or to use an existing IAM instance profile | `bool` | `true` | no |
| <a name="input_default_capacity_provider_use_fargate"></a> [default\_capacity\_provider\_use\_fargate](#input\_default\_capacity\_provider\_use\_fargate) | Determines whether to use Fargate or autoscaling for default capacity provider strategy | `bool` | `false` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The number of Amazon EC2 instances that should be running in the autoscaling group | `number` | `null` | no |
| <a name="input_ecs_optimized_ami_name"></a> [ecs\_optimized\_ami\_name](#input\_ecs\_optimized\_ami\_name) | The SSM parameter name for the ECS optimized AMI | `string` | `"/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | List of egress rules to create by name | `list(string)` | <pre>[<br>  "all-all"<br>]</pre> | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for env e.g. 'l', 's', 't1', 't2' | `string` | `null` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | `EC2` or `ELB`. Controls how health checking is done | `string` | `"EC2"` | no |
| <a name="input_iam_role_policies"></a> [iam\_role\_policies](#input\_iam\_role\_policies) | IAM policies to attach to the IAM role | `map(string)` | <pre>{<br>  "AmazonEC2ContainerServiceforEC2Role": "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",<br>  "AmazonSSMManagedInstanceCore": "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"<br>}</pre> | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_ignore_desired_capacity_changes"></a> [ignore\_desired\_capacity\_changes](#input\_ignore\_desired\_capacity\_changes) | Determines whether the `desired_capacity` value is ignored after initial apply | `bool` | `true` | no |
| <a name="input_ingress_cidr_blocks"></a> [ingress\_cidr\_blocks](#input\_ingress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all ingress rules | `list(string)` | `[]` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | List of ingress rules to create by name | `list(string)` | <pre>[<br>  "ssh-tcp",<br>  "http-80-tcp"<br>]</pre> | no |
| <a name="input_instance_requirements"></a> [instance\_requirements](#input\_instance\_requirements) | Override the instance type in the Launch Template with instance types that satisfy the requirements. If Instance Requirements is defined then can't use instance\_type | `map(any)` | <pre>{<br>  "configuration": {<br>    "excluded_instance_types": [<br>      "t2*",<br>      "r*",<br>      "d*",<br>      "g*",<br>      "i*",<br>      "z*",<br>      "x*"<br>    ],<br>    "memory_mib": {<br>      "max": 16384,<br>      "min": 8192<br>    },<br>    "vcpu_count": {<br>      "max": 4,<br>      "min": 2<br>    }<br>  }<br>}</pre> | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for capacity provider. | `string` | `"t3.medium"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The key name that should be used for the instance | `string` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "region", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_launch_template_version"></a> [launch\_template\_version](#input\_launch\_template\_version) | Launch template version. Can be version number, `$Latest`, or `$Default` | `string` | `"$Latest"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum size of the autoscaling group | `number` | `null` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum size of the autoscaling group | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'rds' or 'ecs'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_on_demand_allocation_strategy"></a> [on\_demand\_allocation\_strategy](#input\_on\_demand\_allocation\_strategy) | Allocation strategy for on-demand instances. Use lowest-price for cost-efficiency, as it selects the cheapest On-Demand instance types available in the chosen instance pool. | `string` | `"lowest-price"` | no |
| <a name="input_on_demand_autoscaling_base"></a> [on\_demand\_autoscaling\_base](#input\_on\_demand\_autoscaling\_base) | Base tasks for default capacity provider strategy for on-demand. | `number` | `20` | no |
| <a name="input_on_demand_autoscaling_target_capacity"></a> [on\_demand\_autoscaling\_target\_capacity](#input\_on\_demand\_autoscaling\_target\_capacity) | Target capacity for on-demand auto-scaling. | `number` | `60` | no |
| <a name="input_on_demand_autoscaling_weight"></a> [on\_demand\_autoscaling\_weight](#input\_on\_demand\_autoscaling\_weight) | Weight for default capacity provider strategy for on-demand. | `number` | `60` | no |
| <a name="input_on_demand_base_capacity"></a> [on\_demand\_base\_capacity](#input\_on\_demand\_base\_capacity) | Base capacity for on-demand instances. Set this to match the minimum baseline capacity required for your workload that cannot tolerate interruptions, such as critical real-time applications or steady-state services. | `number` | `1` | no |
| <a name="input_on_demand_percentage_above_base_capacity"></a> [on\_demand\_percentage\_above\_base\_capacity](#input\_on\_demand\_percentage\_above\_base\_capacity) | Percentage above base capacity for on-demand instances. 0% for workloads tolerant of interruptions, maximizing Spot Instance usage and reducing costs. | `number` | `80` | no |
| <a name="input_protect_from_scale_in"></a> [protect\_from\_scale\_in](#input\_protect\_from\_scale\_in) | Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events. | `bool` | `true` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | ID element. Usually used for region, e.g. 'eu-central-1', 'ap-northeast-1' | `string` | `null` | no |
| <a name="input_spot_allocation_strategy"></a> [spot\_allocation\_strategy](#input\_spot\_allocation\_strategy) | Allocation strategy for spot instances. Use price-capacity-optimized for workloads that need high availability but then spot\_instance\_pools can't be used | `string` | `"lowest-price"` | no |
| <a name="input_spot_autoscaling_target_capacity"></a> [spot\_autoscaling\_target\_capacity](#input\_spot\_autoscaling\_target\_capacity) | Target capacity for spot auto-scaling. | `number` | `90` | no |
| <a name="input_spot_autoscaling_weight"></a> [spot\_autoscaling\_weight](#input\_spot\_autoscaling\_weight) | Weight for default capacity provider strategy for spot. | `number` | `40` | no |
| <a name="input_spot_instance_pools"></a> [spot\_instance\_pools](#input\_spot\_instance\_pools) | Number of spot instance pools. A higher number increases the diversity of Spot capacity pools the Auto Scaling Group can consider, reducing the chance of running out of Spot capacity. | `number` | `5` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_termination_policies"></a> [termination\_policies](#input\_termination\_policies) | A list of policies to decide how the instances in the Auto Scaling Group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `OldestLaunchTemplate`, `AllocationStrategy`, `Default` | `list(string)` | <pre>[<br>  "ClosestToNextInstanceHour"<br>]</pre> | no |
| <a name="input_user_data_append"></a> [user\_data\_append](#input\_user\_data\_append) | Additional user data to append to the default ECS configuration. | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where to create security group | `string` | `null` | no |
| <a name="input_vpc_zone_identifier"></a> [vpc\_zone\_identifier](#input\_vpc\_zone\_identifier) | A list of subnet IDs to launch resources in. Subnets automatically determine which availability zones the group will reside. Conflicts with `availability_zones` | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN that identifies the cluster |
| <a name="output_cluster_autoscaling_capacity_providers"></a> [cluster\_autoscaling\_capacity\_providers](#output\_cluster\_autoscaling\_capacity\_providers) | Map of capacity providers created and their attributes |
| <a name="output_cluster_capacity_providers"></a> [cluster\_capacity\_providers](#output\_cluster\_capacity\_providers) | Map of cluster capacity providers attributes |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID that identifies the cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name that identifies the cluster |
<!-- END_TF_DOCS -->