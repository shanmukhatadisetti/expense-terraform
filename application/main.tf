resource "aws_instance" "instance" {
  ami           = data.aws_ami.ami.image_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.sg.id]

  tags = {
    Name = var.component
  }
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "${var.component}.${var.zone_id}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

resource "null_resource" "frontend" {
  depends_on = [aws_route53_record.record]
  provisioner "local-exec" {
    command = <<EOF
cd /home/centos/expense-ansible
git pull
sleep 60
ansible-playbook -i ${aws_instance.instance.private_ip}, -e ansible_user=centos -e ansible_password=DevOps321 expense.yml -e role_name=${var.component}
EOF
  }
}