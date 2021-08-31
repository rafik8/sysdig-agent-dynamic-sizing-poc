resource "kubernetes_daemonset" "sysdig-agent" {
  metadata {
    name      = "sysdig-agent"
    namespace = var.sysdig_agent_namespace
    labels = {
      app = "sysdig-agent"
      tier =  "PA"
    }
  }

  spec {
    revision_history_limit = 10
    selector {
      match_labels = {
        app = "sysdig-agent"
        tier =  "PA"
      }
    }

    template {
      metadata {
        labels = {
          app = "sysdig-agent"
          tier =  "PA"
        }
      }

      spec {
        automount_service_account_token = true
        volume {
          name = "modprobe-d"
          host_path {
              path = "/etc/modprobe.d"
          } 
        }

        volume {
          name = "osrel"
          host_path {
              path = "/etc/os-release"
              type ="FileOrCreate"
          } 
        }

        volume {
          name = "dshm"
          empty_dir {
              medium = "Memory"
          } 
        }

        volume {
          name = "dev-vol"
          host_path {
              path = "/dev"
          } 
        }

        volume {
          name = "proc-vol"
          host_path {
              path = "/proc"
          } 
        }

        volume {
          name = "boot-vol"
          host_path {
              path = "/boot"
          } 
        }

        volume {
          name = "modules-vol"
          host_path {
              path = "/lib/modules"
          } 
        }

        volume {
          name = "usr-vol"
          host_path {
              path = "/usr"
          } 
        }

        volume {
          name = "run-vol"
          host_path {
              path = "/run"
          } 
        }

        volume {
          name = "varrun-vol"
          host_path {
              path = "/var/run"
          } 
        }

        volume {
          name = "sysdig-agent-config"
          config_map {
              name = "sysdig-agent"
              optional = true
          } 
        }

        volume {
          name = "sysdig-agent-secrets"
          secret {
              secret_name = "sysdig-agent"
          } 
        }

        container {
          image = "quay.io/sysdig/agent:latest"
          image_pull_policy = "Always"
          name  = "sysdig-agent"

          resources {
            limits = {
              cpu    =  local.resource_limit_cpu
              memory = local.resource_limit_mem
            }
            requests = {
              cpu    =  local.resource_request_cpu
              memory = local.resource_request_mem
            }
          }

          readiness_probe {

            exec {
              command= ["test", "-e", "/opt/draios/logs/running"]
            } 
            failure_threshold = 3
            initial_delay_seconds = 10
            period_seconds = 10
            success_threshold = 1
            timeout_seconds= 1
          }

          volume_mount {
            mount_path = "/etc/modprobe.d"
            name       = "modprobe-d"
            read_only = true
          } 

          volume_mount {
            mount_path = "/host/dev"
            name       = "dev-vol"
            read_only = false
          }

          volume_mount {
            mount_path = "/host/proc"
            name       = "proc-vol"
            read_only = true
          } 

          volume_mount {
            mount_path = "/host/boot"
            name       = "boot-vol"
            read_only = true
          }

          volume_mount {
            mount_path = "/host/lib/modules"
            name       = "modules-vol"
            read_only = true
          } 

          volume_mount {
            mount_path = "/host/usr"
            name       = "usr-vol"
            read_only = true
          } 

          volume_mount {
            mount_path = "/host/run"
            name       = "run-vol"
          } 

          volume_mount {
            mount_path = "/host/var/run"
            name       = "varrun-vol"
          }

          volume_mount {
            mount_path = "/dev/shm"
            name       = "dshm"          
          } 

          volume_mount {
            mount_path = "/opt/draios/etc/kubernetes/config"
            name       = "sysdig-agent-config"          
          }

          volume_mount {
            mount_path = "/opt/draios/etc/kubernetes/secrets"
            name       = "sysdig-agent-secrets"          
          }

          volume_mount {
            mount_path = "/host/etc/os-release"
            name       = "osrel"
            read_only = true
          }
          
        }
      }
    }
  }
}