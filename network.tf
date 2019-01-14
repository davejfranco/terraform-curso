#Compartment
resource "oci_identity_compartment" "test_compartment" {
    #Required
    compartment_id = "${var.tenancy_ocid}"
    description = "A compartment to test OCI with terraform deployment"
    name = "IAC_demo"

    #Optional
    freeform_tags = {"Environment"= "${var.env}"}
}

#Virtual Network
resource "oci_core_vcn" "test_vcn" {
    #Required
    cidr_block = "${var.vcn_cidr_block}"
    compartment_id = "${oci_identity_compartment.test_compartment.id}"

    #Optional
    display_name = "${var.vcn_display_name}"
    freeform_tags = {"Environment"= "${var.env}"}
}

#Internet Gateway
resource "oci_core_internet_gateway" "test_ig" {
    #Required
    compartment_id = "${oci_identity_compartment.test_compartment.id}"
    vcn_id = "${oci_core_vcn.test_vcn.id}"

    #Optional
    display_name = "test_internet_gateway"
    freeform_tags = {"Environment"= "${var.env}"}
}

#First Subnet
resource "oci_core_subnet" "test_subnet" {
    count = "${length(var.vcn_pub_nets)}"
    #Required
    availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[count.index], "name")}"
    cidr_block = "${element(var.vcn_pub_nets, count.index)}"
    compartment_id = "${oci_identity_compartment.test_compartment.id}"
    security_list_ids = ["${oci_core_vcn.test_vcn.default_security_list_id}"]
    vcn_id = "${oci_core_vcn.test_vcn.id}"

    #Optional
    display_name = "subnet_${count.index}"
    freeform_tags = {"Environment"= "${var.env}"}
    route_table_id = "${oci_core_vcn.test_vcn.default_route_table_id}"
}