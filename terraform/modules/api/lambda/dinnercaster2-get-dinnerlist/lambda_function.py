import boto3

def lambda_handler(event, context):
  dynamodb = boto3.resource('dynamodb')

  table = dynamodb.Table('dinnercaster2-v0.1')

  response = table.scan()
  items = response['Items']
  print(items)

  return items
