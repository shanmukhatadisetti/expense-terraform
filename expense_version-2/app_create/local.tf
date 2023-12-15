locals {
  ami = data.aws_ami.ami.image_id
  zone_id = data.aws_route53_zone.zone_id.id
}