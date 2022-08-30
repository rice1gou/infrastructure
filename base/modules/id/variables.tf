#
# Define Variables to be Used in the Identity Module
#

variable "resource_group_name" {
  description = "配置先となるリソースグループ名"
}

variable "resource_group_id" {
  description = "配置先となるリソースグループID"
}

variable "location" {
  description = "リソースの配置先となるリージョン"
}

variable "name_prefix" {
  description = "名称に付けるプリフィックス"
}
