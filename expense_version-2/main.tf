module "expense" {
  source = "./app_create"
  component = frontend
}

module "expense" {
  source = "./app_create"
  component = backend
}

module "expense" {
  source = "./app_create"
  component = mysql
}
