#Variable file

#Auth
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "env" {
    default = "devlopment"
  
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
  default = "vcn_test"
}

