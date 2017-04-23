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

resource "aws_elasticache_cluster" "frequency_redis" {
  cluster_id = "frequency-cluster"
  engine = "redis"
  engine_version = "3.2.4"
  node_type = "cache.t2.micro"
  port = 6379
  num_cache_nodes = 1
  parameter_group_name = "default.redis3.2"
}

resource "aws_lambda_function" "rekonnaissance_lambda" {
  filename = "${var.parse_lambda_filename}"
  function_name = "rekonnaissance_lambda"
  description = "Grabs images, labels them, and stores information in redis"
  role = "${aws_iam_role.parse_lambda_role.arn}"
  handler = "index.handler"
  runtime = "nodejs6.10"
  timeout = 240
  memory_size = 128
  depends_on = [
    "aws_iam_role.parse_lambda_role"]
  environment = {
    variables = {
      ELASTICACHE_HOST = "${var.elasticache_host}"
    }
  }
  depends_on = ["aws_elasticache_cluster.frequency_redis"]
}

resource "aws_cloudwatch_event_rule" "rekonnaissance_lambda_every_hour" {
  name = "rekonnaissance_lambda_every_hour"
  description = "Triggers rekonnaissance lambda to execute every hour"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "trigger_rekonnaissance_lambda_every_hour" {
  rule = "${aws_cloudwatch_event_rule.rekonnaissance_lambda_every_hour.name}"
  target_id = "rekonnaissance_lambda"
  arn = "${aws_lambda_function.rekonnaissance_lambda.arn}"
  input = "{}"
}

resource "aws_lambda_permission" "cloudwatch_rekonnaissance_lambda_permission" {
  statement_id = "cloudwatch_rekonnaissance_lambda_permission"
//  action = "lambda:InvokeFunction"
  action = "lambda:DisableInvokeFunction"
  function_name = "${aws_lambda_function.rekonnaissance_lambda.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.rekonnaissance_lambda_every_hour.arn}"
}

