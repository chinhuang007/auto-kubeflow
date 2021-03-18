terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.21.2"
    }
  }
}

provider "ibm" {
  # Configuration options
  region = var.region
  ibmcloud_api_key = var.ibmcloud_api_key
}

resource "ibm_resource_instance" "appid_instance" {
  name     = "${var.name}${var.name_suffix}"
  service  = "appid"
  plan     = var.plan
  location = var.region
}

resource "ibm_iam_service_id" "appid_serviceid" {
  name        = "serviceid_4_appid${var.name_suffix}"
  description = "service id for appid"
}

resource "ibm_resource_key" "resource_key" {
  name                 = "manager_credentials${var.name_suffix}"
  role                 = "Manager"
  resource_instance_id = ibm_resource_instance.appid_instance.id
  parameters = {
    serviceid_crn = ibm_iam_service_id.appid_serviceid.crn
  }
}

