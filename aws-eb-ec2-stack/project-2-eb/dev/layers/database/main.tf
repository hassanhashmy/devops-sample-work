
resource "aws_security_group" "RdsSecurityGroup" {
  count  = var.create ? 1 : 0
  vpc_id = var.vpc_id
  name   = "${var.EnvName}-${var.rds_sg}"
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.EnvName}-${var.rds_sg}"
  }
}


module "rds" {
  source                  = "terraform-aws-modules/rds/aws"
  version                 = "4.3.0"
  count                   = var.create ? 1 : 0
  identifier              = "${var.EnvName}-${var.masterdbidentifier}"
  engine                  = var.db_engine
  instance_class          = var.db_instance
  allocated_storage       = var.allocated_storage
  username                = var.db_username
  password                = var.db_password
  publicly_accessible     = true
  skip_final_snapshot     = true
  availability_zone       = var.VPCZone1
  backup_retention_period = 5
  vpc_security_group_ids  = [aws_security_group.RdsSecurityGroup[0].id]
  create_db_subnet_group  = true
  subnet_ids              = var.Privatesubnets_ids
  family                  = "postgres13"

}

resource "aws_db_instance" "replica_master" {
  count                   = var.create ? 1 : 0
  replicate_source_db     = "${var.EnvName}-${var.masterdbidentifier}"
  identifier              = "${var.EnvName}-${var.masterdbidentifier}-replica"
  instance_class          = var.db_instance
  allocated_storage       = var.allocated_storage
  backup_retention_period = 0
  availability_zone       = var.VPCZone1
  skip_final_snapshot     = true
  tags = {
    Name = "${var.EnvName}-${var.masterdbidentifier}-replica"
  }
  depends_on = [module.rds]
}


















