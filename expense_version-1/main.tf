resource "aws_instance" "frontend" {
  ami           = [data.aws_ami.ami.image_id]
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-019ae3d5fa113c712"]

  tags = {
    Name = "frontend"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = "Z10413961HT8PFBW9XTRT"
  name    = "frontend.autonagar.com"
  type    = "A"
  ttl     = 30
  records = [aws_instance.frontend.private_ip]
}

resource "aws_instance" "backend" {
  ami           = "ami-03265a0778a880afb"
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-019ae3d5fa113c712"]

  tags = {
    Name = "backend"
  }
}

resource "aws_route53_record" "backend" {
  zone_id = "Z10413961HT8PFBW9XTRT"
  name    = "backend.autonagar.com"
  type    = "A"
  ttl     = 30
  records = [aws_instance.backend.private_ip]
}

resource "aws_instance" "mysql" {
  ami           = "ami-03265a0778a880afb"
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-019ae3d5fa113c712"]

  tags = {
    Name = "mysql"
  }
}

resource "aws_route53_record" "mysql" {
  zone_id = "Z10413961HT8PFBW9XTRT"
  name    = "mysql.autonagar.com"
  type    = "A"
  ttl     = 30
  records = [aws_instance.mysql.private_ip]
}