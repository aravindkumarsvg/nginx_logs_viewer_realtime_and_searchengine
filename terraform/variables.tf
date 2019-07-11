variable "docker_images" {
  default = {
    nginx           = "aravindkumars/nginx:1.0"
    nginx-fluentd   = "aravindkumars/nginx-fluentd:1.0"
    kafka-consumer  = "aravindkumars/kafka-nginx-consumer:1.0"
    realtime-viewer = "aravindkumars/realtime-viewer:1.0"
  }
}
