#Connection to Oracle cloud
# 

provider "oci" {
  version      = ">= 3.0.0"
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

module "network" {
  source = "modules/network"

  env = "dev"

  tenancy_ocid = "${var.tenancy_ocid}"
  compartment_id = "${var.dave_compartment_id}"
  compartment_name = "terraform_net_demo"
  vcn_cidr_block = "${var.vcn_cidr_block}"
  vcn_display_name = "${var.vcn_display_name}"
  vcn_pub_nets = "${var.vcn_pub_nets}"  
  vcn_priv_nets = "${var.vcn_priv_nets}"

}

resource "oci_identity_compartment" "oke_compartment" {
    #Required
    compartment_id = "${var.dave_compartment_id}"
    description = "oke compartment"
    name = "k8s_clusters"

    #Optional
    freeform_tags = {"Environment"= "${var.env}"}
}

module "oke" {
  #source = "modules/oke"
  source = "git@github.com:davejfranco/terraform-oke.git?ref=develop"

  compartment_id = "${oci_identity_compartment.oke_compartment.id}"
  k8s_version = "v1.12.7"
  cluster_name = "oke_demo_cluster"
  vcn_id = "${module.network.vcn_id}"
  service_lb_subnet_ids = ["${element(module.network.public_subnets, 0)}", "${element(module.network.public_subnets, 1)}"]
  node_pool_name = "np_demo_1"
  node_pool_subnet_ids = ["${element(module.network.public_subnets, 2)}"]
  node_pool_environment = "dev"
  node_pool_ssh_public_key = "${file("~/.ssh/id_rsa.pub")}"

}

