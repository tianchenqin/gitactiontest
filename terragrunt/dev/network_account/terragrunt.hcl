
locals {
    env_variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    region = try(local.env_variables.locals.region, "eu-central-1")
    account_name = "network_${try(local.env_variables.locals.env, "dev")}"
    remote_state_bucket = "testforremote"
    tablestore_endpoint = try(local.env_variables.locals.tablestore_endpoint, "https://test-remote.cn-hangzhou.tablestore.aliyuncs.com") # 请替换为你的TabStore实例端点
    tablestore_instance = "test-remote"
    tablestore_table    = try(local.env_variables.locals.tablestore_table, "test_remote") # 请替换为你的锁表名称
}

terraform {
  source = "../../../modules//network_account"
}

remote_state {
  backend = "oss"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket              = local.remote_state_bucket
    prefix              = "${path_relative_to_include()}" # 根据相对路径自动生成状态文件路径
    key                 = "terraform.tfstate" # 状态文件名称
    region              = local.region
    tablestore_endpoint = local.tablestore_endpoint # 用于状态锁的TabStore实例端点
    tablestore_table    = local.tablestore_table    # 用于状态锁的表名
    # encrypt           = true # 如果需要服务器端加密可以开启
    # acl               = "private" # 默认就是private，可根据需要调整
  }
}

inputs = {
    region = local.region
    account_name = local.account_name
    default_tag = merge(try(local.env_variables.locals.default_tag, {}), { account = local.account_name })
    instance_type = "ecs.g6.large"
    name = "network-${try(local.env_variables.locals.env, "dev")}"
    vswitch_id = "vsw-bp1vjxcg1gj32uxjcil6v"    
    vpc_id = "vpc-bp1mk1nbx1smpl1xaqhkw"
    zone_id= "cn-hangzhou-h" # 举例，确保与vswitch所在可用区匹配

}

# generate "provider" {
#     path = "provider.tf"
#     if_exists = "overwrite"
#     contents = <<EOF
# terraform {
#     required_providers {
#         alicloud = {
#             source  = "aliyun/alicloud"
#             version = "1.259.0"
#         }
#     }
# }

# provider "alicloud" {
#     access_key = "xxxx"     
#     secret_key = "xxxx"
#     region     = "cn-hangzhou"
# }
# EOF
# }
generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite"
    contents = <<EOF
terraform {
    required_providers {
        alicloud = {
            source  = "aliyun/alicloud"
            version = "1.259.0"
        }
    }
}

# 定义变量（值将从 Terragrunt 传递的 -var 参数获取）
variable "alicloud_access_key" {
    type      = string
    sensitive = true  # 标记为敏感，避免日志泄露
}

variable "alicloud_secret_key" {
    type      = string
    sensitive = true
}

# 引用变量（值来自 GitHub Secrets → 环境变量 → Terragrunt → Terraform 变量）
provider "alicloud" {
    access_key = var.alicloud_access_key
    secret_key = var.alicloud_secret_key
    region     = "${local.region}"  
    
}
EOF
}