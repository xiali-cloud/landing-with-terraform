variable "name" {
  default = "tf_example"
}

resource "alicloud_dcdn_waf_policy" "example" {
  defense_scene = "waf_group"
  policy_name   = var.name
  policy_type   = "custom"
  status        = "on"
}

resource "alicloud_dcdn_waf_rule" "example" {
  policy_id = alicloud_dcdn_waf_policy.example.id
  rule_name = var.name
  conditions {
    key      = "URI"
    op_value = "ne"
    values   = "/login.php"
  }
  conditions {
    key      = "Header"
    sub_key  = "a"
    op_value = "eq"
    values   = "b"
  }
  status    = "on"
  cc_status = "on"
  action    = "monitor"
  effect    = "rule"
  rate_limit {
    target    = "IP"
    interval  = "5"
    threshold = "5"
    ttl       = "1800"
    status {
      code  = "200"
      ratio = "60"
    }
  }
}