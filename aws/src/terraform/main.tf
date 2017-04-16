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

resource "aws_iam_role" "parse_lambda_role" {
  name = "parse_lambda_role"
  assume_role_policy = "${file("../policies/lambda-role.json")}"
}

resource "aws_iam_role_policy" "parse_lambda_policy" {
  name = "parse_lambda_policy"
  role = "${aws_iam_role.parse_lambda_role.id}"
  policy = "${file("../policies/lambda-policy.json")}"
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

resource "aws_lambda_function" "parse_lambda" {
  filename = "${var.parse_lambda_filename}"
  function_name = "parse_lambda"
  description = "Grabs images, labels them, and stores information in redis"
  role = "${aws_iam_role.parse_lambda_role.arn}"
  handler = "index.handler"
  runtime = "nodejs4.3"
  timeout = 240
  memory_size = 128
  depends_on = [
    "aws_iam_role.parse_lambda_role"]
}

