#
#Define Variables to be Used in the Local Environment
#

variable "infrastructure_group_name" {
  description = "AzureADのインフラ管理ユーザーグループ名"
}

variable "base_resource_group_name" {
  description = "基盤となるリソースの配置先となるリソースグループ名"
}

variable "structure_resource_group_name" {
  description = "配置先となるリソースグループ名"
}

variable "location" {
  description = "リソースの配置先となるリージョン"
}

variable "administrator_login" {
  description = "PostgreSQLの管理者ID"
}

variable "administrator_password" {
  description = "PostgreSQLの管理者パスワード"
}
