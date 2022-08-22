variable "resource_group_name" {
  description = "配置先となるリソースグループ名"
}

variable "location" {
  description = "リソースの配置先となるリージョン"
}

variable "name_prefix" {
  description = "名称に付けるプリフィックス"
}

variable "soft_delete_retention_days" {
  description = "論理削除後のデータ保持日数"
}

variable "sku_name" {
  description = "KeyvaultのSKUの名前"
}

variable "purge_protection_enabled" {
	description = "パージに対する保護が有効になっているか"
}