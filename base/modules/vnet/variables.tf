variable "resource_group_name" {
  description = "virtual networkの配置先となるリソースグループ名"
}

variable "location" {
  description = "リソースの配置先となるリージョン"
}

variable "name_prefix" {
  description = "名称に付けるプリフィックス"
}

variable "address_space" {
  description = "virtual networkのアドレス範囲"
}