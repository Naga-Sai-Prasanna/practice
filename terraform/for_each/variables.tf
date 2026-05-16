variable "instances" {
    type = map()
    default = {
      mongodb = "t3.micro"
      redis = "t3.small"
    }
 }