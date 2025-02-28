data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

data "alicloud_instance_types" "default" {
  availability_zone = data.alicloud_zones.default.zones[0].id
  cpu_core_count    = 1
  memory_size       = 2
}

data "alicloud_images" "default" {
  name_regex  = "^ubuntu_18.*64"
  most_recent = true
  owners      = "system"
}

variable "name" {
  default = "RouteEntryConfig"
}

resource "alicloud_vpc" "foo" {
  vpc_name   = var.name
  cidr_block = "10.1.0.0/21"
}

resource "alicloud_vswitch" "foo" {
  vpc_id       = alicloud_vpc.foo.id
  cidr_block   = "10.1.1.0/24"
  zone_id      = data.alicloud_zones.default.zones[0].id
  vswitch_name = var.name
}

resource "alicloud_security_group" "tf_test_foo" {
  name        = var.name
  description = "foo"
  vpc_id      = alicloud_vpc.foo.id
}

resource "alicloud_security_group_rule" "ingress" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.tf_test_foo.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_instance" "foo" {
  security_groups = [alicloud_security_group.tf_test_foo.id]

  vswitch_id = alicloud_vswitch.foo.id

  instance_charge_type       = "PostPaid"
  instance_type              = data.alicloud_instance_types.default.instance_types[0].id
  internet_charge_type       = "PayByTraffic"
  internet_max_bandwidth_out = 5

  system_disk_category = "cloud_efficiency"
  image_id             = data.alicloud_images.default.images[0].id
  instance_name        = var.name
}

resource "alicloud_route_entry" "foo" {
  route_table_id        = alicloud_vpc.foo.route_table_id
  destination_cidrblock = "172.11.1.1/32"
  nexthop_type          = "Instance"
  nexthop_id            = alicloud_instance.foo.id
}
