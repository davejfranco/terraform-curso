#Compartment
resource "oci_identity_compartment" "net_compartment" {
    #Required
    compartment_id = "${var.compartment_id}"
    description = "A compartment to test OCI with terraform deployment"
    name = "${var.compartment_name}"

    #Optional
    freeform_tags = {"Environment"= "${var.env}"}
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
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

#Public Access
#Internet Gateway
resource "oci_core_internet_gateway" "net_ig" {
    #Required
    compartment_id = "${oci_identity_compartment.net_compartment.id}"
    vcn_id = "${oci_core_vcn.vcn.id}"

    #Optional
    display_name = "test_internet_gateway"
    freeform_tags = {"Environment"= "${var.env}"}
}



#Route Table
resource "oci_core_route_table" "net_pub_route_table" {
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
    display_name = "Public Route Table"
    freeform_tags = {"Environment"= "${var.env}"}
}

#Public Subnets
resource "oci_core_subnet" "net_pub_subnets" {
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
    route_table_id = "${oci_core_route_table.net_pub_route_table.id}"
}

#Private Access
resource "oci_core_nat_gateway" "net_nat_gw" {
    #Required
    compartment_id = "${oci_identity_compartment.net_compartment.id}"
    vcn_id = "${oci_core_vcn.vcn.id}"

    #Optional
    display_name = "${var.nat_gateway_display_name}"
    freeform_tags = {
        "Environment"= "${var.env}"
        }
}


resource "oci_core_route_table" "net_priv_route_table" {
    #Required
    compartment_id = "${oci_identity_compartment.net_compartment.id}"
    route_rules {
        #Required
        network_entity_id = "${oci_core_nat_gateway.net_nat_gw.id}"
        #Optional
        destination = "0.0.0.0/0"
    }
    vcn_id = "${oci_core_vcn.vcn.id}"

    #Optional
    display_name = "Private Route Table"
    freeform_tags = {"Environment"= "${var.env}"}
}

resource "oci_core_subnet" "net_priv_subnets" {
    count = "${length(var.vcn_priv_nets)}"
    #Required
    availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[count.index], "name")}"
    cidr_block = "${element(var.vcn_priv_nets, count.index)}"
    compartment_id = "${oci_identity_compartment.net_compartment.id}"
    security_list_ids = ["${oci_core_vcn.vcn.default_security_list_id}"]
    vcn_id = "${oci_core_vcn.vcn.id}"

    #Optional
    prohibit_public_ip_on_vnic = true
    display_name = "priv_subnet_${lookup(data.oci_identity_availability_domains.ads.availability_domains[count.index], "name")}_${count.index + 1}"
    freeform_tags = {"Environment"= "${var.env}"}
    route_table_id = "${oci_core_route_table.net_priv_route_table.id}"

}
