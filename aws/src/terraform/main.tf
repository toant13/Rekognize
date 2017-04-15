provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

variable "access_key" {
}
variable "secret_key" {
}
variable "region" {
  default = "us-east-1"
}

resource "aws_elasticache_cluster" "FrequencyRedis" {
  cluster_id = "frequency-cluster"
  engine = "redis"
  engine_version = "3.2.4"
  node_type = "cache.t2.micro"
  port = 6379
  num_cache_nodes = 1
  parameter_group_name = "default.redis3.2"
}