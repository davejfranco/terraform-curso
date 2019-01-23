#Connection to Oracle cloud
provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

#Get a list of Availability Domains


#Output the result
# output "show-ads" {
#   value = "${data.oci_identity_availability_domains.ads.availability_domains}"
# }


module "network" {
  source = "modules/network"

  env = "dev"

  tenancy_ocid = "${var.tenancy_ocid}"
  vcn_cidr_block = "${var.vcn_cidr_block}"
  vcn_display_name = "${var.vcn_display_name}"
  vcn_pub_nets = "${var.vcn_pub_nets}"  

}

output "vcn" {
  value = "${module.network.vcn_id}"
}
