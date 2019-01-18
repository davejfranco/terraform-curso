#Compartment
resource "oci_identity_compartment" "net_compartment" {
    #Required
    compartment_id = "${var.tenancy_ocid}"
    description = "A compartment to test OCI with terraform deployment"
    name = "IAC_demo"

    #Optional
    freeform_tags = {"Environment"= "${var.env}"}
}

#Virtual Network
resource "oci_core_vcn" "vcn" {
    #Required
    cidr_block = "${var.vcn_cidr_block}"
    compartment_id = "${oci_identity_compartment.net_compartment.id}"

    #Optional
    display_name = "${var.vcn_display_name}"
    freeform_tags = {"Environment"= "${var.env}"}
}

#Internet Gateway
resource "oci_core_internet_gateway" "net_ig" {
    #Required
    compartment_id = "${oci_identity_compartment.net_compartment.id}"
    vcn_id = "${oci_core_vcn.vcn.id}"

    #Optional
    display_name = "test_internet_gateway"
    freeform_tags = {"Environment"= "${var.env}"}
}


#First Subnet
resource "oci_core_subnet" "net_subnets" {
    count = "${length(var.vcn_pub_nets)}"
    #Required
    availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[count.index], "name")}"
    cidr_block = "${element(var.vcn_pub_nets, count.index)}"
    compartment_id = "${oci_identity_compartment.net_compartment.id}"
    security_list_ids = ["${oci_core_vcn.vcn.default_security_list_id}"]
    vcn_id = "${oci_core_vcn.vcn.id}"

    #Optional
    display_name = "pub_subnet_${lookup(data.oci_identity_availability_domains.ads.availability_domains[count.index], "name")}_${count.index + 1}"
    freeform_tags = {"Environment"= "${var.env}"}
    route_table_id = "${oci_core_vcn.vcn.default_route_table_id}"
}

#Route Table
resource "oci_core_route_table" "net_route_table" {
    #Required
    compartment_id = "${oci_identity_compartment.net_compartment.id}"
    route_rules {
        #Required
        network_entity_id = "${oci_core_internet_gateway.net_ig.id}"
        #Optional
        destination = "0.0.0.0/0"
    }
    vcn_id = "${oci_core_vcn.vcn.id}"

    #Optional
    display_name = "main"
    freeform_tags = {"Environment"= "${var.env}"}
}

resource "oci_core_route_table_attachment" "net_route_table_attachment" {
  count = "${length(var.vcn_pub_nets)}"
  #Required 
  #subnet_id = "${oci_core_subnet.test_subnet.id}"
  subnet_id = "${element(oci_core_subnet.net_subnets.*.id, count.index)}"
  route_table_id ="${oci_core_route_table.net_route_table.id}"
}
