module "expense" {
  source = "./app_create"
  component = var.component
}

variable "component" {
  default = ["frontend","backend","mysql"]
}