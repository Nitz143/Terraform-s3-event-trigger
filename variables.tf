variable "aws_region" {
    description = "value of aws region"
    type = string
    default = "ap-south-1"
  
}

variable "redis_cluster_name" {
    description = "Cluster Name to be provided to redis cluster"
    type = string
    default = "test-redis-cluster"
  
}

variable "bucket_name" {
  type    = string
  default = "your-s3-bucket-16"
}
