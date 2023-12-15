module "frontend" {
  source = "./app_create"
  component = "frontend"
}

module "backend" {
  source = "./app_create"
  component = "backend"
}

module "mysql" {
  source = "./app_create"
  component = "mysql"
}
