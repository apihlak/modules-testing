### TEST
module "label" {
  source = "git::ssh://git@github.com/coingaming/infra-modules.git//modules/global/label?ref=main"

  context = module.this.context
}

module "rds" {
  # https://github.com/terraform-aws-modules/terraform-aws-rds
  source  = "terraform-aws-modules/rds/aws"
  version = "6.10.0"

  # Name of the RDS instance
  identifier = module.label.id

  # To get possible engine options the following command can be used
  # ~$ aws rds describe-db-engine-versions | jq '[.DBEngineVersions[].Engine]|unique|sort'
  engine = var.engine

  # To get possible engine version options the following command can be used. Replace 'postgres' with your desired engine
  # ~$ aws rds describe-db-engine-versions | jq '.DBEngineVersions[]|select(.Engine=="postgres")|.EngineVersion'
  engine_version = var.engine_version

  # List of possible instance types https://aws.amazon.com/rds/instance-types/
  # Note: db instance types may differ from ec2 options
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  iops              = var.iops

  db_name                             = var.db_name
  username                            = var.username
  port                                = var.port
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  vpc_security_group_ids              = var.vpc_security_group_ids


  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Maintenance.html#Concepts.DBMaintenance
  maintenance_window = var.maintenance_window

  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ManagingAutomatedBackups.html#USER_WorkingWithAutomatedBackups.BackupWindow
  backup_window = var.backup_window

  monitoring_interval    = var.monitoring_interval
  monitoring_role_name   = var.monitoring_role_name
  create_monitoring_role = var.create_monitoring_role

  tags = module.label.tags

  create_db_subnet_group          = var.create_db_subnet_group
  db_subnet_group_name            = module.label.id
  db_subnet_group_use_name_prefix = var.db_subnet_group_use_name_prefix
  subnet_ids                      = var.subnet_ids

  create_db_parameter_group       = var.create_db_parameter_group
  parameter_group_name            = module.label.id
  parameter_group_use_name_prefix = var.parameter_group_use_name_prefix


  # To get possible family version options the following command can be used. Replace 'postgres' with your desired engine
  # ~$ aws rds describe-db-engine-versions | jq '[.DBEngineVersions[]|select(.Engine=="postgres")|.DBParameterGroupFamily]|unique|sort'
  family = var.family

  deletion_protection = var.deletion_protection

}
