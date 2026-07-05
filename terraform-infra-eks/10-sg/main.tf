
# for single sec group
# module "sg" {
#     source =  "../../terraform-aws-sg"
#     project = var.project
#     environment = var.environment 
#     sg_name = "mongodb"
#     vpc_id = local.vpc_id
    
# }




module "sg" {
    count = length(var.sg_names)
    source =  "../../terraform-aws-sg"
    project = var.project
    environment = var.environment 
    #here for ex: backend_alb sec group the name will be like roboshop-dev-backend_alb.that's why we are using this to replace _ to -
    sg_name = replace(var.sg_names[count.index], "_", "-")
    vpc_id = local.vpc_id
    
}