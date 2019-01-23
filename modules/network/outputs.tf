output "net_compartment" {
  value = "${oci_identity_compartment.net_compartment.id}"
}

output "vcn_id" {
  value = "${oci_core_vcn.vcn.id}"
}

output "internet_gateway_id" {
  value = "${oci_core_internet_gateway.net_ig.id}"
}

output "public_subnets" {
  value = ["${oci_core_subnet.net_subnets.*.id}"]
}

output "route_table_id" {
  value = "${oci_core_route_table.net_route_table.id}"
}

