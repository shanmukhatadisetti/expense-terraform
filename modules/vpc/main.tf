resource "aws_vpc" "dev-vpc" {
  cidr_block = var.vpc_cidr
}