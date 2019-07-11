resource "helm_release" "kibana" {
  name       = "kibana"
  chart      = "stable/kibana"
  repository = "${data.helm_repository.stable.metadata.0.name}"

  set_string {
    name  = "files.kibana\\.yml.elasticsearch\\.hosts"
    value = "http://elasticsearch.default.svc.cluster.local:9200"
  }

  depends_on = ["kubernetes_service.elasticsearch"]
}

output "kibana_port_forward_cmd" {
  value = "kubectl port-forward KIBANA_POD_NAME 5601:5601"
}
