#
# Define Variables to be Used in the PostgreSQL Module
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

variable "vnet_id" {
  description = "リソースの配置先となるバーチャルネットid"
}

variable "subnet_id" {
  description = "リソースの配置先となるサブネットid"
}

variable "sku_name" {
  description = "ストレージのスペック"
}

variable "storage_mb" {
  description = "DBのストレージ容量"
}

variable "backup_retention_days" {
  description = "backupの保存期間"
}

variable "administrator_login" {
  description = "DB管理者のログインID"
}

variable "administrator_password" {
  description = "DB管理者のログインパスワード"
}
