# Creates a data source that's supposed to be an S3 object. Data from here can be used
# In params for other resources
data "aws_s3_object" "update_visitor_count_lambda" {
  bucket = "sanadams.click"
  key    = "update_visitor_counter.zip"
}

# Creates aws lambda resource with relevant params
resource "aws_lambda_function" "update_visitor_count" {
  s3_bucket         = data.aws_s3_object.update_visitor_count_lambda.bucket
  s3_key            = data.aws_s3_object.update_visitor_count_lambda.key
  function_name = "update_visitor_count"
  role = "arn:aws:iam::730335353044:role/DynamoDBLambda"
  runtime = "python3.9"
  handler       = "update_visitor_counter.lambda_handler"
}

# outputs the arn for use in other terraform configs
output "update_visitor_count_arn" {
  value = aws_lambda_function.update_visitor_count.arn
}
