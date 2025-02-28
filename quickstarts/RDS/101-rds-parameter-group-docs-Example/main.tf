variable "name" {
  default = "tf_example"
}

resource "alicloud_rds_parameter_group" "default" {
  engine         = "mysql"
  engine_version = "5.7"
  param_detail {
    param_name  = "back_log"
    param_value = "4000"
  }
  param_detail {
    param_name  = "wait_timeout"
    param_value = "86460"
  }
  parameter_group_desc = var.name
  parameter_group_name = var.name
}
