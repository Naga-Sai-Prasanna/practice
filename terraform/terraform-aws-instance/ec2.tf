#here we creating aws instance 
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids   =  var.sg_ids  #here attaching sec group to ec2
  
  tags = local.ec2_final_tags 
}





