
data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}



data "aws_ssm_parameter" "database_subnet_group_name" {
  name = "/${var.project}/${var.environment}/database_subnet_group_name" 
}


# mysql sg_id


data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.environment}/mysql_sg_id"    
}