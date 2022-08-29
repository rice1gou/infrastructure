#
# Define Variables to be Used in the Local Environment
#

variable "base_resource_group_name" {
  description = "配置先となるリソースグループ名"
}

variable "location" {
  description = "リソースの配置先となるリージョン"
}

variable "address_space" {
  description = "vnetのアドレス範囲"
  type        = list(string)
}

variable "infrastructure_group_name" {
  description = "AzureADのインフラ管理ユーザーグループ名"
}