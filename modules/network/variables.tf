variable "tenancy_ocid" { type = "string" }

variable "compartment_id" { type = "string" }

variable "compartment_name" { type = "string" default = "network"}

variable "env" { type = "string" }
variable "vcn_cidr_block" { type = "string" }
variable "vcn_display_name" { type = "string" }
variable "vcn_pub_nets" { type = "list" }

variable "vcn_priv_nets" { type = "list" }

variable "nat_gateway_display_name" { type = "string" default = "VCN Nat Gateway"}
