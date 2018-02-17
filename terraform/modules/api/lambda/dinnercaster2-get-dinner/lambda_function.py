import boto3
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
  dynamodb = boto3.resource('dynamodb')
  table = dynamodb.Table('dinnercaster2-v0.1')
  response = table.query(
    KeyConditionExpression=Key('dinnername').eq(event['dinnername'])
    )
  item = response['Items']
  print(item)

  return item
