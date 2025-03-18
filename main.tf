module "expense" {
  count = 3
  source = "./application"
  component = var.expense[count.index]
}

variable "expense" {
  default = [ "frontend", "backend", "mysql"]
}