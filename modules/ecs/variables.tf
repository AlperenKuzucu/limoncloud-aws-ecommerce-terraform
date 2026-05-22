data "aws_region" "current" {}

variable "project" {}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "ecs_subnets" {}

variable "target_group_arn" {}