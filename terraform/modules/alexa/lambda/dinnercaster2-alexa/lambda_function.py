import boto3
import json

# --------------- Helpers that build all of the responses ----------------------

def build_speechlet_response(title, output):
    return {
        'outputSpeech': {
            'type': 'PlainText',
            'text': output
        },
        'card': {
            'type': 'Simple',
            'title': "SessionSpeechlet - " + title,
            'content': "SessionSpeechlet - " + output
        },
    }


def build_response(session_attributes, speechlet_response):
    return {
        'version': '1.0',
        'sessionAttributes': session_attributes,
        'response': speechlet_response
    }

# --------------- Functions that control the skill's behavior ------------------

def get_dinner_response():
    client = boto3.client('lambda')

    response = client.invoke(
        FunctionName='dinnercaster2-get-dinnerlist'
    )

    dinners = json.loads(response['Payload'].read())

    for i in range(len(dinners)):
      print(dinners[i]['dinnername'])
      print(dinners[i]['scores'])

      scores = json.loads(dinners[i]['scores'])
      print(scores['GeneralScore'])

    card_title = "Dinnercaster"
    speech_output = "Here's your dinner idea: " + dinners[0]['dinnername']
    return build_response(None, build_speechlet_response(
        card_title, speech_output))

# --------------- Events ------------------

def on_intent(intent_request):
    print("on_intent requestId=" + intent_request['requestId'])

    intent = intent_request['intent']
    intent_name = intent_request['intent']['name']

    # Dispatch to your skill's intent handlers
    if intent_name == "DinnerCasterIntent":
        return get_dinner_response()
    elif intent_name == "AMAZON.HelpIntent":
        return
    elif intent_name == "AMAZON.CancelIntent" or intent_name == "AMAZON.StopIntent":
        return
    else:
        raise ValueError("Invalid intent")

# --------------- Main handler ------------------

def lambda_handler(event, context):

    """
    Uncomment this if statement and populate with your skill's application ID to
    prevent someone else from configuring a skill that sends requests to this
    function.
    """
    # if (event['session']['application']['applicationId'] !=
    #         "amzn1.echo-sdk-ams.app.[unique-value-here]"):
    #     raise ValueError("Invalid Application ID")
    if event['request']['type'] == "LaunchRequest":
        return get_dinner_response()
    if event['request']['type'] == "IntentRequest":
        return on_intent(event['request'])
