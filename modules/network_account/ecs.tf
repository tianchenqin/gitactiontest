
# Create a new ECS instance for a VPC
resource "alicloud_security_group" "group" {
  security_group_name = var.name
  description         = "testsg"
  vpc_id              = var.vpc_id
}



# data "alicloud_ots_tables" "tables_ds" {
#   instance_name = "test-remote" 
#   output_file   = "tables.txt"
# }

# output "first_table_id" {
#   value = "${data.alicloud_ots_tables.tables_ds.tables.0.id}"
# }
# resource "alicloud_instance" "test_instance" {
#   instance_name   = var.instance_name
#   instance_type   = var.instance_type
#   image_id        = var.image_id
#   vswitch_id      = var.vswitch_id
#   security_groups = [alicloud_security_group.group.id] # 假设安全组ID也通过变量传递
#   availability_zone = var.zone_id # 或 zone_id = var.zone_id
#   system_disk_category = "cloud_efficiency"
#   system_disk_size     = 40

#   internet_max_bandwidth_out = 0 # 分配公网IP并设置带宽  
# }
