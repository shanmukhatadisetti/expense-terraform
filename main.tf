module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  env = var.env
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  azs = var.azs
  peer_owner_id = var.peer_owner_id
  default_vpc_id = var.default_vpc_id
  default_vpc_cidr = var.default_vpc_cidr
  default_route_table_id = var.default_route_table_id
}

module "public_alb" {
  source = "./modules/alb"

  alb_sg_allow_cidr = "0.0.0.0/0"
  alb_type          = "public"
  env               = var.env
  internal          = false
  subnets           = module.vpc.public_subnets
  vpc_id            = module.vpc.vpc_id
  dns_name          = "${var.env}.autonagar.in"
  zone_id           = "Z10413961HT8PFBW9XTRT"
  tg_arn            = module.frontend.tg_arn
}

module "private_alb" {
  source = "./modules/alb"

  alb_sg_allow_cidr = var.vpc_cidr
  alb_type          = "private"
  env               = var.env
  internal          = true
  subnets           = module.vpc.private_subnets
  vpc_id            = module.vpc.vpc_id
  dns_name          = "backend-${var.env}.autonagar.in"
  zone_id           = "Z10413961HT8PFBW9XTRT"
  tg_arn            = module.backend.tg_arn
}

module "frontend" {
  source = "./modules/application-servers"

  application-server_port   = 80
  component                 = "frontend"
  env                       = var.env
  instance_type             = "t3.micro"
  subnets                   = module.vpc.private_subnets
  vpc_cidr                  = var.vpc_cidr
  vpc_id                    = module.vpc.vpc_id
  bastion_node_cidr         = var.bastion_node_cidr
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  prometheus_cidr           = var.prometheus_cidr
}

module "backend" {
  source = "./modules/application-servers"
  depends_on = [module.mysql]

  application-server_port   = 8080
  component                 = "backend"
  env                       = var.env
  instance_type             = "t3.micro"
  subnets                   = module.vpc.private_subnets
  vpc_cidr                  = var.vpc_cidr
  vpc_id                    = module.vpc.vpc_id
  bastion_node_cidr         = var.bastion_node_cidr
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  prometheus_cidr           = var.prometheus_cidr
}

module "mysql" {
  source = "./modules/rds"

  component = "mysql"
  env       = var.env
  subnets   = module.vpc.private_subnets
  vpc_cidr  = var.vpc_cidr
  vpc_id    = module.vpc.vpc_id
  instance_class = var.instance_class
}