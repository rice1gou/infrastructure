#
# Define Variables to be Used in the Develop Environment
#

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
  describe = "PostgreSQLの管理者ID"
}

variable "administrator_password" {
  describe = "PostgreSQLの管理者パスワード"
}
