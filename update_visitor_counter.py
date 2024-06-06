import json
import boto3

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('site_stats')  

def lambda_handler(event, context):

    # Extract the stat_name from the request body
    request_body = json.loads(event['body'])
    stat_name = request_body.get('stat_name')

     # Update the quantity of the specified stat
    response = table.update_item(
        Key={'stat_name': stat_name},
        UpdateExpression='set quantity = quantity + :val',
        ExpressionAttributeValues={':val': 1},
        ReturnValues='UPDATED_NEW'
    )        

    # Extract the updated quantity from the response
    updated_quantity = response['Attributes']['quantity']

    # Construct the response body
    response_body = {
        'quantity': int (updated_quantity)  
    }

    # Return the response body
    return {
        'statusCode': 200,
        'body': json.dumps(response_body),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,X-Amz-Security-Token,Authorization,X-Api-Key,X-Requested-With,Accept,Access-Control-Allow-Methods,Access-Control-Allow-Origin,Access-Control-Allow-Headers',  
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        }
    }
