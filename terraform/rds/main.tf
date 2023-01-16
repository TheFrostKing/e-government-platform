# Create DB parameter for RDS
resource "aws_db_parameter_group" "rdsgov" {
  name   = "rdsgov"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

# Create subnet group for RDS
resource "aws_db_subnet_group" "rdsgov" {
  name       = "rdsgov"
  subnet_ids = var.database_subnets.*.id
}

# Create DB instance
resource "aws_db_instance" "rdsgov" {
  identifier             = "rdsgov"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = "edu"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rdsgov.name
  vpc_security_group_ids = var.rds_service_security_groups
  parameter_group_name   = aws_db_parameter_group.rdsgov.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}