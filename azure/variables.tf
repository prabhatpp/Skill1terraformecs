variable "aks_resource_group_name" {
  description = "Resource group name for the Azure AKS cluster"
  type        = string
  default     = "rg-skill1-aks"
}

variable "aks_location" {
  description = "Azure region for the AKS cluster"
  type        = string
  default     = "eastus"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "skill1-aks"
}

variable "aks_dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "skill1aks"
}

variable "aks_kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
  default     = "1.29.4"
}

variable "aks_node_count" {
  description = "Number of worker nodes in the default AKS node pool"
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "VM size for AKS worker nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "aks_admin_username" {
  description = "Admin username for the AKS Linux nodes"
  type        = string
  default     = "azureuser"
}

variable "aks_ssh_public_key" {
  description = "SSH public key used for AKS Linux nodes"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0l2v2c8jBY1bV3aR8z0jvG3FStz2Cm1uJ2bHhNNfq7h1k9r0WfF2lNXDvcQJdGq7vK5bS2s9T6Y3Q2V3vL0nP2jZ3nOnkK9a2m6q5vN1T/7DWqhe2q2hU1VJlsA5S+ZcyR3vKdL0S2b6eJb58y3aD2dJ0gk9Y2xq6Qxnhp4Ylv1B5xQ=="
}
