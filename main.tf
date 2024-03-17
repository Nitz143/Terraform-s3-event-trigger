
#AWS Elas<Cache (Redis) cluster
resource "aws_elasticache_cluster" "example" {
  cluster_id           = var.redis_cluster_name
  engine               = "redis"
  engine_version       = "6.x"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  port                 = 6379
  parameter_group_name = "default.redis6.x"
}


#Create a iam role for lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}


# Create AWS Lambda Function
resource "aws_lambda_function" "s3_trigger_example" {
  filename      = "./lambda_code/lambda_function.zip"
  function_name = "s3_lambda_trigger"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout     = 60
  
}

#Create S3 Policy
resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

#Create Cloudwatch Policy
resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  #policy_arn = "arn:aws:iam::aws:policy/AWSLambdaBasicExecutionRole"  
}


#Create S3 Bucket
resource "aws_s3_bucket" "your_s3_bucket" {
  bucket = var.bucket_name 
  acl    = "private"
}

#Create Lambda Permission
resource "aws_lambda_permission" "s3_lambda_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_trigger_example.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.your_s3_bucket.arn
}


#Create S3 Bucket Notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.your_s3_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_trigger_example.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [ 
    aws_lambda_permission.s3_lambda_permission
  
   ]


}

#Create Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "s3_trigger_cloudwatch" {
  name = "/aws/lambda/${aws_lambda_function.s3_trigger_example.function_name}"
  retention_in_days = 7

}



