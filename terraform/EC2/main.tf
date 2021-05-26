resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_size
  key_name                    = var.ssh_key
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true
  tags = {
    "Name" = var.name
  }
}
