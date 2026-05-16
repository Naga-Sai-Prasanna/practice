data "aws_availability_zones" "avaialble" {
  state = "available"
}

data "aws_vpc" "default" {
    default = true
}

data "aws_route_table" "default" {
    vpc_id = data.aws_vpc.default.id
    filter {
      name = "association_main"
      values = ["true"]
    }
}