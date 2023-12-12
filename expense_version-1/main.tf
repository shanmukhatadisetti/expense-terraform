resource "aws_instance" "frontend" {
  ami           = data.aws_ami.ami.image_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = {
    Name = "frontend"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.zone_id.id
  name    = "frontend.${var.zone_id}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.frontend.private_ip]
}

resource "null_resource" "frontend" {
  depends_on = [aws_route53_record.frontend.zone_id]
  provisioner "local-exec" {
    command = <<EOF
cd /home/centos/expense-terraform/expense_version-1
git pull
ansible-playbook ${aws_instance.frontend.private_ip}, ansible_user=centos ansible_password=DevOps321 main.yml -e role_name=frontend
EOF
  }
}

resource "aws_instance" "backend" {
  ami           = data.aws_ami.ami.image_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = {
    Name = "backend"
  }
}

resource "aws_route53_record" "backend" {
  zone_id = data.aws_route53_zone.zone_id.id
  name    = "backend.${var.zone_id}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.backend.private_ip]
}

resource "null_resource" "backend" {
  depends_on = [aws_route53_record.backend.zone_id]
  provisioner "local-exec" {
    command = <<EOF
cd /home/centos/expense-terraform/expense_version-1
git pull
ansible-playbook ${aws_instance.backend.private_ip}, ansible_user=centos ansible_password=DevOps321 main.yml -e role_name=backend
EOF
  }
}

resource "aws_instance" "mysql" {
  ami           = data.aws_ami.ami.image_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = {
    Name = "mysql"
  }
}

resource "aws_route53_record" "mysql" {
  zone_id = data.aws_route53_zone.zone_id.id
  name    = "mysql.${var.zone_id}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.mysql.private_ip]
}

resource "null_resource" "mysql" {
  depends_on = [aws_route53_record.mysql.zone_id]
  provisioner "local-exec" {
    command = <<EOF
cd /home/centos/expense-terraform/expense_version-1
git pull
ansible-playbook ${aws_instance.mysql.private_ip}, ansible_user=centos ansible_password=DevOps321 main.yml -e role_name=mysql
EOF
  }
}