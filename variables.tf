#Variable file

#Auth
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "env" {
    default = "development"
  
}

#Network
variable "vcn_cidr_block" {
  default = "172.16.0.0/16"
}

variable "vcn_pub_nets" {
    type = "list"
    default = [
        "172.16.1.0/24",
        "172.16.2.0/24",
        "172.16.3.0/24"
    ]
}

variable "vcn_priv_nets" {
    default = [
        "172.16.4.0/24",
        "172.16.5.0/24",
        "172.16.6.0/24"
    ]
}

variable "vcn_display_name" {
  default = "terraform_demo_vcn"
}

# #Kubernetes Cluster
# variable "compartment_id" { type = "string" }
# variable "k8s_version" { type = "string" }

# variable "cluster_name" { type = "string" }

# variable "vcn_id" { type = "string" }

# variable "k8s_dashboard_enabled" { type = "bool" default = true }
# variable "k8s_tiller_enabled" { type = "bool" default = true }

# variable "service_lb_subnet_ids" { type = "list" }

# variable "node_pool_name" { type = "string" }
# variable "node_pool_subnet_ids" { type = "list" }
# variable "node_pool_environment" { type = "string" }
# variable "node_pool_quantity_per_subnet" { type = "number" default = 1 }

# variable "node_pool_ssh_public_key" { type = "string" }