//hey!
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

    #Optional
    defined_tags = {"Operations.CostCenter"= "42"}
    display_name = "${var.autonomous_database_display_name}"
    freeform_tags = {"Department"= "Finance"}
    license_model = "${var.autonomous_database_license_model}"
}