provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  ibmcloud_timeout = 300
}

data "ibm_iam_auth_token" "tokendata" {}

provider "sysdig" {
  # Configuration options
  sysdig_monitor_url       = var.sysdig_monitor_url
  sysdig_monitor_api_token = var.sysdig_monitor_api_token # data.ibm_iam_auth_token.tokendata.iam_access_token #
  extra_headers = {
    IBMInstanceID = data.ibm_resource_instance.monitoring.guid
    Authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
  }
}
