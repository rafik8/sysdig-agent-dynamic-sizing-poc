resource "kubernetes_config_map" "sysdig-agent" {
  metadata {
    name = "sysdig-agent"
    namespace = var.sysdig_agent_namespace
    labels = {
      app = "sysdig-agent"
    }

  }

  data = {
    "dragent.yaml" = <<EOF
### Agent tags # tags: linux:ubuntu,dept:dev,local:nyc
	
metrics_excess_log: true

#### Sysdig Software related config ####


# Sysdig collector address

# collector: 192.168.1.1


# Collector TCP port

# collector_port: 6666


# Whether collector accepts ssl

# ssl: true


# collector certificate validation

# ssl_verify_certificate: true


#######################################

# new_k8s: true

# k8s_cluster_name: production

security:
	k8s_audit_server_url: 0.0.0.0
	k8s_audit_server_port: 7765    
	k8s_cluster_name: ku00ei000006/bpof69cf0ubl1g3ij9n0/admin
tags: ibm.containers-kubernetes.cluster.id:bpof69cf0ubl1g3ij9n0,ibm_scope:a/9623e3be58ba47aa8be25554f6d41c7e

collector: ingest.private.eu-de.monitoring.cloud.ibm.com

collector_port: 6443

ssl: true

ssl_verify_certificate: true

sysdig_capture_enabled: false

log:
	file_priority: info
	#console_priority: warning
	console_priority: info
	
metrics_excess_log: true

use_promscrape: true
prometheus:
	ingest_raw: true
	ingest_calculated: false
	enabled: true
	max_metrics: 10000
	process_filter:
	- exclude:
		process.name: docker-proxy
	- exclude:
		container.image: sysdig/agent
	# special rule to exclude processes matching configured prometheus appcheck
	- exclude:
		appcheck.match: prometheus
	- include:
		container.label.io.prometheus.scrape: \"true\"
		conf:
			# Custom path definition
			# If the label doesn't exist we'll still use \"/metrics\"
			path: \"{container.label.io.prometheus.path}\"
			# Port definition
			# - If the label exists, only scan the given port.
			# - If it doesn't, use port_filter instead.
			# - If there is no port_filter defined, skip this process
			port: \"{container.label.io.prometheus.port}\"
			port_filter:
				- exclude: [9092,9200,9300]
				- include: 9090-9500
				- include: [9913,9984,24231,42004]
	- exclude:
		container.label.io.prometheus.scrape: \"false\"
	- include:
		kubernetes.pod.annotation.prometheus.io/scrape: true
		kubernetes.pod.annotation.prometheus.io/scheme: \"https\"
		conf:
			use_https: true
			path: \"{kubernetes.pod.annotation.prometheus.io/path}\"
			port: \"{kubernetes.pod.annotation.prometheus.io/port}\"
	- include:
		kubernetes.pod.annotation.prometheus.io/scrape: true
		conf:
			path: \"{kubernetes.pod.annotation.prometheus.io/path}\"
			port: \"{kubernetes.pod.annotation.prometheus.io/port}\"
	- exclude:
		kubernetes.pod.annotation.prometheus.io/scrape: false

new_k8s: true 
process:
	flush_filter_enabled: true
	flush_filter:
	- include:
		process.name: java 
	- include:
		container.name: sidecar
		process.name: httpd 
	- include:
		all

watchdog:
	max_memory_usage_mb: ${local.max_memory_usage_mb}
	max_memory_usage_subprocesses:
	sdchecks: 128
	sdjagent: 256
	mountedfs_reader: 32
	statsite_forwarder: 32
	cointerface: ${local.cointerface}
	
feature:
	mode: troubleshooting
	
metrics_excess_log: true
EOF

  }
}