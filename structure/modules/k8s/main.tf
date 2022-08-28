#
# Define Resources Associated With The Kubernetes
#

# Create Kubernetes
resource "azurerm_kubernetes_cluster" "example" {
	name = "${var.name_prefix}-k8s"
	location = var.location
	resource_group_name = var.resource_group_name
	dns_prefix = "${var.name_prefix}-k8s"
	
	# Define Node Pool
	default_node_pool {
		name = "${var.name_prefix}-node_pool"
		node_count = var.node_count
		vm_size = var.vm_size
		enable_auto_scaling = false
		vnet_subnet_id = var.subnet_id
	}

	# Define Authorization Identity Type
	identity {
		type = "SystemAssigned"
	}

	# Define Secret Store CSI Driver
	key_vault_secrets_provider {
			secret_rotation_enabled = true
			secret_rotation_interval = var.secret_rotation_interval
	}

	# Define Network Policy
	network_profile {
		network_plugin = "kubenet"
		network_policy = "calico"
		load_balancer_sku = "standard"

		# Define Loadbalancer
		load_balancer_profile {
			managed_outobund_i_address = 1
			idle_timeout_in_minutes = 30
		}
	}
}