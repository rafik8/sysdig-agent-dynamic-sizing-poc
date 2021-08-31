
data "ibm_resource_group" "group" {
  name = var.resource_group
}

data "ibm_container_vpc_cluster" "k8s-cluster" {
  name = var.cluster_name
}

data "ibm_container_cluster_config" "clusterConfig" {
  cluster_name_id   = data.ibm_container_vpc_cluster.k8s-cluster.id
  resource_group_id = data.ibm_resource_group.group.id
  config_dir        = "/tmp"
}


provider "kubernetes" {
  config_path = data.ibm_container_cluster_config.clusterConfig.config_file_path
}

# resource "kubernetes_namespace" "var.sysdig_agent_namespace" {
#   metadata {
#     name = var.sysdig_agent_namespace
#   }
# }

provider "helm" {
  debug = true

  kubernetes {
    config_path = data.ibm_container_cluster_config.clusterConfig.config_file_path
  }
}

data "ibm_resource_instance" "monitoring" {
  name              = var.monitoring_instance_name
  location          = var.region
  resource_group_id = data.ibm_resource_group.group.id
}




