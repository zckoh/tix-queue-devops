###########################################
# Jenkins VM
###########################################
resource "aws_security_group" "jenkinsVM" {
  name        = "allow-ec2-access"
  description = "Allow EC2 access"
  vpc_id      = module.vpc.vpc_id

  # To be change to only access from setupVM  
  ingress {
    description      = "SSH from Anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP 8080 from anywhere"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-ec2-access"
  }
}

resource "aws_key_pair" "setupVMKeyPair" {
  key_name   = "setupVMKey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpjvm98x7wLqtbPFDo1BqqxLEutp6Dk+k3ue/mucfaqe58a829wpIITU5V7LZDotA215h+J8rIIJ3Ew5OBtinf4/q5ytd4FYYnsTa1+o7TwicTmQ3GIcZ0EpshtursLYmJievfxPkiWGbaSFfBBG20kEOyxb5vRxDiNHuNkXNEAGRXbFwICcEd0lpCrVb04XwTpJgZlNDyDc9/v6qI0j8njnlhOdl1eNsqYpSI94tyErKiTMx71OHm2SvSyRAXbZIEUg8dirY4jGn95o25mn1RKJpRp5bP5FaWyXLLc6JKJjWvHOyK3Ow7IKQl/biUj5zRon8RXr/yJw6uV1KFa53E8WHh8UHu6mkVAS+x7YYgVbiadYAaU5Za3XOB4sRUy6N/9ytvGpmxe0iGx2llVwMtqJT+hCqJNFYqyf2plhGbMjGEtb3P2h81T6vd825jK+A6BWU4Q6VLBDaB2wR8F2C0ANY9OM1odCLswBNLwCIQf6j3syOLsaS0TtUQLBgITrs= ubuntu@ip-172-31-1-130"
}

module "jenkinsVM" {
  name               = "jenkinsVM"
  source             = "./EC2"
  ssh_key            = aws_key_pair.setupVMKeyPair.key_name
  instance_size      = var.jenkinsVM_instance_size
  subnet_id          = element(module.vpc.public_subnets, 0)
  security_group_ids = [module.vpc.default_security_group_id, aws_security_group.jenkinsVM.id]
}
