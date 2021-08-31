resource "kubernetes_cluster_role" "sysdig-agent" {
  metadata {
    name = "sysdig-agent"
  }

  rule {
    api_groups = [""]
    resources  = ["pods","replicationcontrollers","services","endpoints","events","limitranges","namespaces","nodes","resourcequotas","persistentvolumes","persistentvolumeclaims"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["daemonsets","deployments","replicasets","statefulsets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs","jobs"]
    verbs      = ["get", "list", "watch"]
  }
  
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies"]
    verbs      = ["get", "list", "watch"]
  }
  
  rule {
    api_groups = ["extensions"]
    resources  = ["daemonsets", "deployment", "ingresses", "replicasets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["get", "list", "create","update","watch"]
  }
}