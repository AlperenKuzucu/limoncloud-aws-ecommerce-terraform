module "acm" {
  source = "../modules/acm"

  domain_name = "limoncloud-101.com"
}


module "amazon-mq" {
  source             = "../modules/amazon-mq"
  broker_name        = "${var.project}-${var.env}-mq"
  engine_type        = "RabbitMQ"
  engine_version     = "3.9.16"
  host_instance_type = "mq.m5.large"
  username           = "${var.project}-${var.env}"
  port               = 5671
  project            = "${var.project}-${var.env}"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = module.vpc.vpc_cidr
  data_subnets       = module.vpc.data_subnets
}


module "cloudfront" {
  source = "../modules/cloudfront"

  project = lower(var.project)
  aliases = "limoncloud-101.com"

  acm_certificate_arn    = module.acm.acm_certificate_arn
  load_balancer_dns_name = module.load_balancer.load_balancer_dns_name
}


module "codepipeline" {
  source = "../modules/codepipeline"

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr

  private_subnets = module.vpc.private_subnets
}

module "ecr" {
  source = "../modules/ecr"
}


module "ecs" {
  source = "../modules/ecs"

  project  = "${var.project}-${var.env}"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr

  ecs_subnets      = module.vpc.private_subnets
  target_group_arn = module.load_balancer.target_group_arn
}


module "efs" {
  source       = "../modules/efs"
  vpc_id       = module.vpc.vpc_id
  efs_name     = "${var.project}-${var.env}"
  data_subnets = module.vpc.data_subnets
  vpc_cidr     = module.vpc.vpc_cidr
}


module "elasticache" {
  source = "../modules/elasticache"

  data_subnets = module.vpc.data_subnets
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = module.vpc.vpc_cidr

  cluster_id      = "limoncloud-101-redis"
  engine          = "redis"
  engine_version  = "6.2"
  node_type       = "cache.t4g.medium"
  num_cache_nodes = 2
  port            = 6379

  parameter_group_name = "default.redis6.x"
}


module "load_balancer" {
  source = "../modules/load-balancer"

  project         = "${var.project}-${var.env}"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  certificate_arn = module.acm.certificate_arn
  domain          = ["limoncloud-101.com"]

}


module "opensearch" {
  source = "../modules/opensearch"

  vpc_id          = module.vpc.vpc_id
  vpc_cidr        = module.vpc.vpc_cidr
  private_subnets = module.vpc.private_subnets

  domain_name      = "limoncloud-101"
  engine_version   = "OpenSearch_1.2"
  instance_type    = "t3.medium.search"
  instance_count   = 2
  master_user_name = "admin"
}


module "rds" {
  source = "../modules/rds"

  vpc_id       = module.vpc.vpc_id
  data_subnets = module.vpc.data_subnets
  vpc_cidr     = module.vpc.vpc_cidr

  project = "${var.project}-${var.env}"

  port               = 3306
  engine             = "aurora-mysql"
  engine_mode        = "provisioned"
  engine_version     = "8.0.mysql_aurora.3.04.1"
  cluster_identifier = "${var.project}-${var.env}-db-cluster"
  database_name      = "limoncloud101db"
  master_username    = "admin"
  instance_class     = "db.t4g.large"
  instance_count     = 2

  preferred_backup_window      = "01:05-01:35"
  preferred_maintenance_window = "sun:02:00-sun:02:30"

}


module "s3" {
  source = "../modules/s3"
}




module "vpc" {
  source = "../modules/vpc"

  project      = "${var.project}-${var.env}"
  vpc_block    = "10.100.0.0/16"
  region       = var.region
  cluster_name = "${var.project}-${var.env}"


  public-subnet-map = [{ name = "${var.project}-${var.env}-Public-1a", az = "${var.region}a", cidr = "10.100.0.0/24" },
  { name = "${var.project}-${var.env}-Public-1b", az = "${var.region}b", cidr = "10.100.1.0/24" }]

  private-subnet-map = [{ name = "${var.project}-${var.env}-Private-1a", az = "${var.region}a", cidr = "10.100.10.0/24" },
  { name = "${var.project}-${var.env}-Private-1b", az = "${var.region}b", cidr = "10.100.11.0/24" }]

  data-subnet-map = [{ name = "${var.project}-${var.env}-Data-1a", az = "${var.region}a", cidr = "10.100.20.0/24" },
  { name = "${var.project}-${var.env}-Data-1b", az = "${var.region}b", cidr = "10.100.21.0/24" }]
}


module "vpn" {
  source = "../modules/vpn"

  instance_type  = "t3.micro"
  project        = "${var.project}-${var.env}"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "waf" {
  source = "../modules/waf"

  web_acl_name = "limoncloud-101-waf"
  description  = "WAF for limoncloud-101 ecommerce website"

  load_balancer_arn = module.load_balancer.load_balancer_arn
}
