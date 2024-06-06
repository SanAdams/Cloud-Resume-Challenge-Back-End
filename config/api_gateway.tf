# Defines an apigateway resource named sanadams_apigateway
resource "aws_apigatewayv2_api" "sanadams_apigateway" {
  name          = "sanadams_apigateway"

  # HTTP API
  protocol_type = "HTTP" 
}

# This configuration defines the API Gateway integration with AWS services
resource "aws_apigatewayv2_integration" "sanadams_apigateway_integration" {
  api_id                 = aws_apigatewayv2_api.sanadams_apigateway.id

  # The gateway will be acting as a proxy, that is it acts like a middleman intaking requests, forwarding them to the correct place and doing the same with responses
  # It will do no processing
  integration_type       = "AWS_PROXY"

  # Tells terraform that the uri is in another terraform file and is actually being 
  # output by that file as something called update_visitor_count_arn
  integration_uri        = aws_lambda_function.update_visitor_count.arn

  # Specifies the HTTP method used to invoke the integration endpoint (the lambda function)
  integration_method = "POST"
}

# Defines a permission that allows a resource (API Gateway in this case) to invoke a lambda function
resource "aws_lambda_permission" "sanadams_apigateway_update_visitor_count_lambda_permission" {

  # Unique identifier for the permission statement 
  statement_id  = "AllowAPIGatewayInvoke"

  # Specifies action to be allowed which is invoking a lambda function
  action        = "lambda:InvokeFunction"

  # Specifies the lambda function (Amazon Resource Name - ARN) that the permissions outlined above refer to
  function_name = aws_lambda_function.update_visitor_count.arn

  # Tells terraform which service will be assuming this role
  principal     = "apigateway.amazonaws.com"
}

# Defines the $default route for the API Gateway
resource "aws_apigatewayv2_route" "sanadams_apigateway_default_route" {
  api_id    = aws_apigatewayv2_api.sanadams_apigateway.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.sanadams_apigateway_integration.id}"
}

# This configuration creates a stage named "early dev" for the API Gateway HTTP API 
# identified by aws_apigatewayv2_api.sanadams_apigateway.id
resource "aws_apigatewayv2_stage" "sanadams_apigateway" {
  api_id = aws_apigatewayv2_api.sanadams_apigateway.id
  name   = "early_dev"
}