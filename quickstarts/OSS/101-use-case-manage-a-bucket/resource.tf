resource "alicloud_oss_bucket" "bucket-attr" {
  provider = alicloud.bj-prod

  bucket = "bucket-terraform-${random_integer.default.result}"
  # 静态网站的默认首页和404页面
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  # 访问日志的存储路径
  logging {
    target_bucket = alicloud_oss_bucket.bucket-new.id
    target_prefix = "log/"
  }
  # 文件生命周期规则
  lifecycle_rule {
    id      = "expirationByDays"
    prefix  = "path/expirationByDays"
    enabled = true

    expiration {
      days = 365
    }
  }
  # 防盗链设置
  referer_config {
    allow_empty = true
    referers    = ["http://www.aliyun.com", "https://www.aliyun.com", "http://?.aliyun.com"]
  }
}