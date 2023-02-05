resource "aws_db_instance" "example" {
  identifier        = "example"
  allocated_storage = 50
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  db_name           = "example"
  username          = "admin"
  iops              = 1000
  password          = random_password.rds-example.result
  depends_on = [
    aws_security_group.example-allow-all,
  ]
  vpc_security_group_ids = [
    aws_security_group.example-allow-all.id
  ]
  db_subnet_group_name = aws_db_subnet_group.example-rds.id
  publicly_accessible  = true
  skip_final_snapshot  = true
}

resource "aws_instance" "ec2" {
  ami           = "ami-049ed5fa529109ac4"
  instance_type = "t2.large"
  key_name      = aws_key_pair.ondrejsika.key_name
  security_groups = [
    aws_security_group.allow_all.name,
  ]
}
