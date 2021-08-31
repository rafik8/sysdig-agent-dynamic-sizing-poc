# ---------------------------------------------------- #
# REQUIRED
# These variables are expected to be passed in
# ---------------------------------------------------- #

variable "ibmcloud_api_key" {
  description = "You IAM based API key. https://cloud.ibm.com/docs/iam?topic=iam-userapikey"
  type        = string
}

variable "sysdig_ingestion_key" {
  description = "Sysdig instance ingestion key"
  type        = string
}

# variable "resources_prefix" {
#   description = "Prefix is added to all resources that are created by this template."
#   type        = string
# }

# ---------------------------------------------------- #
# OPTIONAL A
# These variables have good enough defaults for most.
# ---------------------------------------------------- #

variable "region" {
  description = "The IBM Cloud region to deploy the resources under."
  type        = string
  default = "us-south"
}

variable "resource_group" {
  description = "The resource group for all the resources created."
  default     = "default"
}

variable "kube_version" {
  default = "1.20.7"
}


variable "monitoring_instance_name" {
  description = "Name of the monitoring service instance."
  type        = string
}

variable "sysdig_monitor_url" {
  description = "URL of the monitoring service instance."
  type        = string
  default = "https://eu-fr2.monitoring.cloud.ibm.com"
}

variable "sysdig_monitor_api_token" {
  description = "Sysdig Monitor API token."
  type        = string
}

# ---------------------------------------------------- #
# Name for Kubernetes cluster in IBM Cloud
# ---------------------------------------------------- #

variable "cluster_name" {
  description = "Name for Kubernetes cluster in IBM Cloud."
  default     = ""
}

# ---------------------------------------------------- #
# Name of the Sysdig agent namespace
# ---------------------------------------------------- #

variable "sysdig_agent_namespace" {
  description = "The Sysdig agent namespace."
  type        = string
  default = "sysdig-agent"
}

# ---------------------------------------------------- #
# Alerts 
# ---------------------------------------------------- #

variable "high_cpu_trigger_after_minutes" {
  description = "High CPU trigger after minutes"
  type        = number
  default = 120
}

# ---------------------------------------------------------#
# Sizing strategy: select the sizing strategy
# 1. "static" based on the Kuberentes cluster family defined by Sysdig 
# (as described here: https://docs.sysdig.com/en/tuning-sysdig-agent-225815.html).
# 2. "dynamic" based on node resources (for example: 2% for the request and 5% for the limit)
# ---------------------------------------------------------#

variable "agent_sizing_strategy" {
  description = "the sizing strategy: can take of the two values: 'static' or 'dynamic' "
  type = string 
  default     = "static"
}

# ------------------------------------------------------------------------------#
# define family band 
# (as described here: https://docs.sysdig.com/en/tuning-sysdig-agent-225815.html).
# N.B: The following values are only used for the 'static' strategy
# -------------------------------------------------------------------------------#


variable "mini_cluster_core_number" {
 description = "The number of core that define a mini cluster"
  type = number 
  default     = 1
}

variable "tiny_cluster_core_number" {
 description = "The number of core that define a tiny cluster"
  type = number 
  default     = 2
}

variable "small_cluster_core_number" {
 description = "The maximum number of core that define a small cluster"
  type = number 
  default     = 8
}

variable "medium_cluster_core_number" {
 description = "The maximum number of core that define a medium cluster"
  type = number 
  default     = 32
}


variable "agent_setup" {

  default = { 
     "mini" = {
        "cpu_request" = "250"
        "cpu_limit" = "250"
        "memory_request" = "1024"
        "memory_limit" = "1024"
        "dragent_limit" = "512"
        "cointerface_limit" = "512"
      },
     "tiny" = {
        "cpu_request" = "500"
        "cpu_limit" = "500"
        "memory_request" = "1024"
        "memory_limit" = "1024"
        "dragent_limit" = "512"
        "cointerface_limit" = "512"
      },
      "small" = {
        "cpu_request" = "1000"
        "cpu_limit" = "1000"
        "memory_request" = "1024"
        "memory_limit" = "1024"
        "dragent_limit" = "512"
        "cointerface_limit" = "512"
      },
      "medium" = {
        "cpu_request" = "3000"
        "cpu_limit" = "3000"
        "memory_request" = "3072"
        "memory_limit" = "3072"
        "dragent_limit" = "1024"
        "cointerface_limit" = "2048"
      },
      "large" = {
        "cpu_request" = "5000"
        "cpu_limit" = "5000"
        "memory_request" = "6144"
        "memory_limit" = "6144"
        "dragent_limit" = "2048"
        "cointerface_limit" = "4096"
      }
  }
}


# ------------------------------------------------------------------#
# N.B: The following values are only used for the 'daynamic' strategy
# Set resource quota for "dynamic" strategy
# ------------------------------------------------------------------#

variable "cpu_request_percentage" {
  description = "Recommended request CPU percentage"
  type = number 
  default     = "0.02"
}

variable "memory_request_percentage" {
  description = "Recommended request Memory percentage"
  type =number 
  default     = "0.02"
}

variable "cpu_limit_percentage" {
  description = "Recommended limit CPU percentage"
  type = number
  default     = "0.05"
}

variable "memory_limit_percentage" {
  description = "Recommended limit Memory percentage"
  type = number 
  default     = "0.05"
}

variable "dragent_memory_percentage" {
  description = "Recommended dragent limit memory percentage"
  type = number 
  default     = "0.33"
}

variable "cointerface_memory_percentage" {
  description = "Recommended cointerface limit memory percentage"
  type = number 
  default     = "0.66"
}