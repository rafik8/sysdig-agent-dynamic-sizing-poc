resource "kubernetes_secret" "sysdig-agent" {
  metadata {
    name = "sysdig-agent"
    namespace = "ibm-observe"
  }

  data = {
    access-key = var.sysdig_ingestion_key
  }

  type = "Opaque"
}