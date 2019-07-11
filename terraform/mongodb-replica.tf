resource "helm_release" "mongodb-kafka" {
    name = "mongodb-kafka"
    chart = "stable/mongodb-replicaset"
    repository = "${data.helm_repository.stable.metadata.0.name}"
}