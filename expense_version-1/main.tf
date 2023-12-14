resource "aws_instance" "frontend" {
  ami           = local.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = {
    Name = "frontend"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = local.zone_id
  name    = "frontend.${var.zone_id}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.frontend.private_ip]
}

resource "null_resource" "frontend" {
  depends_on = [aws_route53_record.frontend]
  provisioner "local-exec" {
    command = <<EOF
cd /home/centos/infra-ansible
git pull
ansible-playbook -i ${aws_instance.frontend.private_ip}, -e ansible_user=centos -e ansible_password=DevOps321 main.yml -e role_name=frontend
EOF
  }
}

resource "aws_instance" "backend" {
  ami           = local.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = {
    Name = "backend"
  }
}

resource "aws_route53_record" "backend" {
  zone_id = local.zone_id
  name    = "backend.${var.zone_id}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.backend.private_ip]
}

resource "null_resource" "backend" {
  depends_on = [aws_route53_record.backend]
  provisioner "local-exec" {
    command = <<EOF
cd /home/centos/infra-ansible
git pull
ansible-playbook -i ${aws_instance.backend.private_ip}, -e ansible_user=centos -e ansible_password=DevOps321 main.yml -e role_name=backend
EOF
  }
}

resource "aws_instance" "mysql" {
  ami           = local.ami
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = {
    Name = "mysql"
  }
}

resource "aws_route53_record" "mysql" {
  zone_id = local.zone_id
  name    = "mysql.${var.zone_id}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.mysql.private_ip]
}

resource "null_resource" "mysql" {
  depends_on = [aws_route53_record.mysql]
  provisioner "local-exec" {
    command = <<EOF
cd /home/centos/infra-ansible
git pull
ansible-playbook -i ${aws_instance.mysql.private_ip}, -e ansible_user=centos -e ansible_password=DevOps321 main.yml -e role_name=mysql
EOF
  }
}

