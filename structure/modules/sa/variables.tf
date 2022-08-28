#
# Define Variables to be Used in the Storage Account Module
#

variable "base_resource_group_name" {
  description = "基盤となるリソースの配置先となるリソースグループ名"
}

variable "resource_group_name" {
  description = "配置先となるリソースグループ名"
}

variable "location" {
  description = "リソースの配置先となるリージョン"
}

variable "name_prefix" {
  description = "名称に付けるプリフィックス"
}

variable "subnet_id" {
  description = "リソースの配置先となるサブネットid"
}

variable account_tier {
  description = "使用するストレージのスペック"
}

variable "account_replication_type" {
  description = "利用するレプリケーションタイプ"
}
