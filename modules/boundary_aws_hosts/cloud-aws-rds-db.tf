resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "13.12"
  instance_class       = "db.t3.micro"
  db_name              = "rdsdb"
  username             = var.aws_db_instance_login_name
  password             = var.aws_db_instance_login_password
  skip_final_snapshot  = true
  publicly_accessible  = true
  allow_major_version_upgrade = true
  db_subnet_group_name = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.boundary_poc.id,aws_security_group.postgres_ingress.id]
}

resource "aws_db_subnet_group" "rds" {
  name       = "postgres"
  subnet_ids = [aws_subnet.boundary_poc.id, aws_subnet.boundary_poc_2.id]
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "postgres_ingress" {
  name   = "${var.prefix}-postgress-ingress"
  vpc_id = aws_vpc.boundary_poc.id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}