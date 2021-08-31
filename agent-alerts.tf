
resource "sysdig_monitor_alert_metric" "agent_high_cpu" {
     
  description           = "Sysdig Agent high CPU utilization"
  name                  = "[Sysdig] Agent High CPU"
  severity              = 4 
  metric                = "avg(min(cpu.used.percent)) > ${local.resource_limit_cpu}"
  scope                 = "kubernetes.daemonSet.name = \"sysdig-agent\" "
  trigger_after_minutes = var.high_cpu_trigger_after_minutes
  multiple_alerts_by    = ["agent.tag.cluster", "host.hostName"]

  custom_notification {
    title = "{{__alert_name__}} is {{__alert_status__}} in {{agent.tag.cluster}}"
  }
}


