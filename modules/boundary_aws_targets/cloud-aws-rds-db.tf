resource "aws_db_instance" "rds" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "13.5"
  instance_class       = "db.t3.micro"
  db_name              = "rdsdb"
  username             = var.aws_db_instance_login_name
  password             = var.aws_db_instance_login_password
  skip_final_snapshot  = true
  publicly_accessible  = true
}