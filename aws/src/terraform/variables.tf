variable "parse_lambda_filename" {
  default = "../../../phase1/functions/rekonnaissance/lambda_v24.zip"
}

variable "elasticache_host" {
  default = "frequency-cluster.u2yttb.0001.use1.cache.amazonaws.com"
}

variable "vpc_security_group" {
  type = "list"
  default = [
    "sg-2da1e356"]
}

variable "vpc_subnet_ids" {
  type = "list"
  default = [
    "subnet-a8e8b3f0",
    "subnet-0d752c27",
    "subnet-8a1728b7",
    "subnet-cfd9b5aa",
    "subnet-5d020b2b"]
}
