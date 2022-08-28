#
# Define Variables to be Used in the Kubernetes Module
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

variable "node_count" {
	description = "デフォルトのノード数"
}

variable "vm_size" {
	description = "ノードに使用するVMのスペック"
}

variable "subnet_id" {
	description = "リソースの配置先となるサブネットid"
}

variable "secret_rotation_interval" {
	description = "CSIドライバーのシークレットの更新頻度"
}
