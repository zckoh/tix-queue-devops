###########################################
# MySQL RDS
###########################################
resource "aws_db_subnet_group" "help_queue" {
  name       = "help-queue-tf-db-subnet-group"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "help-queue-tf-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name   = "help-queue-tf-rds-sg"
  vpc_id = module.vpc.vpc_id

  # ingress {
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "help-queue-tf-rds-sg"
  }
}

resource "aws_db_instance" "help_queue_rds" {
  name                   = "help_queue"
  identifier             = "help-queue-rds"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.23"
  username               = var.rds_username
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.help_queue.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  # publicly_accessible    = true
}
