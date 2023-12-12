data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]
}

data "aws_route53_zone" "zone_id" {
  name         = var.zone_id
}

data "aws_security_group" "sg" {
  name = "allow-all"
}


