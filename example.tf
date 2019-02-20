# Configure the Oracle Cloud Infrastructure provider with an API Key
provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}

# Output the result
output "show-ads" {
  value = "${data.oci_identity_availability_domains.ads.availability_domains}"
}

resource "oci_database_autonomous_database" "test_autonomous_database" {
    #Required
    admin_password = "${var.autonomous_database_admin_password}"
    compartment_id = "${var.compartment_id}"
    cpu_core_count = "${var.autonomous_database_cpu_core_count}"
    data_storage_size_in_tbs = "${var.autonomous_database_data_storage_size_in_tbs}"
    db_name = "${var.autonomous_database_db_name}"

    # #Optional
    display_name = "${var.autonomous_database_display_name}"
    # license_model = "${var.autonomous_database_license_model}"
}

################## compute instance ###########################

resource "oci_core_instance" "test_instance" {
    #Required
    availability_domain = "${var.instance_availability_domain}"
    compartment_id = "${var.compartment_id}"
    shape = "${var.instance_shape}"

    #Optional
    create_vnic_details {
        #Required
        subnet_id = "${oci_core_subnet.test_subnet.id}"

        #Optional
        assign_public_ip = "${var.instance_create_vnic_details_assign_public_ip}"
        defined_tags = {"Operations.CostCenter"= "42"}
        display_name = "${var.instance_create_vnic_details_display_name}"
        freeform_tags = {"Department"= "Finance"}
        hostname_label = "${var.instance_create_vnic_details_hostname_label}"
        private_ip = "${var.instance_create_vnic_details_private_ip}"
        skip_source_dest_check = "${var.instance_create_vnic_details_skip_source_dest_check}"
    }
    defined_tags = {"Operations.CostCenter"= "42"}
    display_name = "${var.instance_display_name}"
    extended_metadata {
        some_string = "stringA"
        nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
    }
    fault_domain = "${var.instance_fault_domain}"
    freeform_tags = {"Department"= "Finance"}
    hostname_label = "${var.instance_hostname_label}"
    ipxe_script = "${var.instance_ipxe_script}"
    is_pv_encryption_in_transit_enabled = "${var.instance_is_pv_encryption_in_transit_enabled}"
    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
        user_data = "${base64encode(file(var.custom_bootstrap_file_name))}"
    }
    source_details {
        #Required
        source_id = "${oci_core_image.test_image.id}"
        source_type = "image"

        #Optional
        boot_volume_size_in_gbs = "60"
        kms_key_id = "${oci_core_kms_key.test_kms_key.id}"
    }
    preserve_boot_volume = false
}