## define agent sizing using local variables

locals {

  # get cluster flavor
  flavor = split( "." ,data.ibm_container_vpc_cluster.k8s-cluster.worker_pools[0].flavor)[1]
  # extract node cpu and memory
  node_cpu = split ("x",local.flavor)[0]
  node_memory = split ("x",local.flavor)[1]
  static_sizing_strategy = "static" 
  # get the cluster type
  cluster_type = (local.node_cpu <= var.mini_cluster_core_number ? "mini" : (local.node_cpu <= var.tiny_cluster_core_number ? "tiny" : (local.node_cpu <= var.small_cluster_core_number ? "small" : (local.node_cpu <= var.medium_cluster_core_number ? "medium" : "large"))))

  # configure agent resources

  resource_request_cpu = var.agent_sizing_strategy == local.static_sizing_strategy ? var.agent_setup[local.cluster_type].cpu_request : ceil(local.node_cpu * 1000 * var.cpu_request_percentage)
  
  resource_limit_cpu =var.agent_sizing_strategy == local.static_sizing_strategy ? var.agent_setup[local.cluster_type].cpu_limit : ceil(local.node_cpu * 1000 * var.cpu_limit_percentage)

  resource_request_mem = var.agent_sizing_strategy == local.static_sizing_strategy ? var.agent_setup[local.cluster_type].memory_request : ceil(local.node_memory * 1024 * var.memory_request_percentage)

  resource_limit_mem = var.agent_sizing_strategy == local.static_sizing_strategy ? var.agent_setup[local.cluster_type].memory_limit : ceil(local.node_memory * 1024 * var.memory_limit_percentage)

  max_memory_usage_mb = var.agent_sizing_strategy == local.static_sizing_strategy ? var.agent_setup[local.cluster_type].dragent_limit: ceil(local.resource_limit_mem*var.dragent_memory_percentage)

  cointerface = var.agent_sizing_strategy == local.static_sizing_strategy ? var.agent_setup[local.cluster_type].cointerface_limit: ceil(local.resource_limit_mem*var.cointerface_memory_percentage)

  # calculate memory and cpu percent for alerting
  resource_limit_cpu_percent = ceil(local.resource_limit_cpu / (local.node_cpu * 1000))
  resource_limit_memory_percent = ceil(local.resource_limit_mem / (local.node_memory * 1024)) 

}