# module "ec2" {
#  source  =  "../terraform-aws-instance" 
#  project = var.project_name                   # if you won't pass here you will get an error │ Error: Missing required argument
#  environment = var.env
#  ami_id = "ami-0c94855ba95c71c99"  #here actually we have to call data source ( data.aws_ami.joindevops.id but i am giving hard coded value because i am not the owner of ami .even if i give it shpws no result for ami.
#  instance_type = "t3.small"
#  sg_ids = var.sg_ids

#     tags = {
#     Name = "${var.project_name}-${var.env}-$(var.component)"
#     component = var.component
#     }

# # }