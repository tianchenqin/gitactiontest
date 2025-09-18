
variable "name" {
  description = "name of sg"
  type        = string
}

variable "image_id" {
  default = "aliyun_3_x64_20G_alibase_20250629.vhd"
}
variable "vpc_id" {
  description = "ID of the VPC where the ECS instance will be created"
  type        = string
}

variable "instance_name" {
  description = "ECS实例名称"
  type        = string
  default     = "tf-test-ecs"
}

variable "instance_type" {
  description = "ECS实例规格"
  type        = string  
}

variable "vswitch_id" {
  description = "虚拟交换机ID"
  type        = string
}

variable "zone_id" {
  description = "The AZ to launch the ECS instance in"
  type        = string
  default     = "cn-hangzhou-h" # 举例，请替换为你的实际可用区ID
}